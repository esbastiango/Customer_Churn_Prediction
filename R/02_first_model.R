# --- 1. Load Libraries ---
# Tidymodels is the main framework, themis is for handling imbalance
install.packages("tidymodels")
install.packages("themis")
install.packages("xgboost")

library(tidymodels)
library(themis) # For SMOTE
library(xgboost)


# --- 2. Load and Prepare Data ---
telco_data <- read_csv("data/WA_Fn-UseC_-Telco-Customer-Churn.csv") %>%
  # The TotalCharges column has some missing values, let's remove them for this MVP
  na.omit() %>%
  # Make the Churn column a factor, which is required for classification
  mutate(Churn = as.factor(Churn))


# --- 3. Split the Data ---
# We need to split our data into a 'training' set (to build the model)
# and a 'testing' set (to evaluate it on unseen data).
# The 'strata' argument ensures both sets have a similar percentage of churners.
set.seed(123) # for reproducibility
telco_split <- initial_split(telco_data, prop = 0.75, strata = Churn)
train_data <- training(telco_split)
test_data  <- testing(telco_split)


# --- 4. Create a Preprocessing Recipe ---
# A recipe defines the steps to prepare data for a model.
telco_recipe <- recipe(Churn ~ ., data = train_data) %>%
  # Convert customerID into a non-predictor role
  update_role(customerID, new_role = "ID") %>%
  # Convert all nominal (text) predictors into numeric dummy variables
  step_dummy(all_nominal_predictors()) %>%
  # Normalize all numeric predictors to have a mean of 0 and std dev of 1
  step_normalize(all_numeric_predictors()) %>%
  # IMPORTANT: Handle class imbalance using SMOTE.
  # This creates synthetic "Yes" churn samples in the training data
  # so the model has more to learn from.
  step_smote(Churn)


# --- 5. Specify the Model ---
# We define the type of model we want to build.
# We're using a boosted tree model with the 'xgboost' engine.
xgb_spec <- boost_tree(
  trees = 1000,
  tree_depth = 6,
  min_n = 10,
  loss_reduction = 0.01,
  sample_size = 0.75,
  mtry = 20,
  learn_rate = 0.05
) %>%
  set_engine("xgboost") %>%
  set_mode("classification")


# --- 6. Create the Workflow ---
# A workflow bundles the recipe and the model together.
xgb_workflow <- workflow() %>%
  add_recipe(telco_recipe) %>%
  add_model(xgb_spec)


# --- 7. Train the Model ---
# Now we fit the workflow to our training data.
xgb_fit <- fit(xgb_workflow, data = train_data)


# --- 8. Evaluate on the Test Set ---
# Let's see how our trained model performs on the unseen test data.
# We'll get a set of performance metrics.
test_results <- predict(xgb_fit, new_data = test_data) %>%
  bind_cols(predict(xgb_fit, new_data = test_data, type = "prob")) %>%
  bind_cols(test_data %>% select(Churn))

# Calculate and print the metrics
yardstick::metrics(test_results, truth = Churn, estimate = .pred_class)
yardstick::roc_auc(test_results, truth = Churn, .pred_No)
