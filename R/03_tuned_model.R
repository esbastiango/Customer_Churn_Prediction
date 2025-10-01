# --- 1. Load Libraries ---
library(tidymodels)
library(themis)
library(xgboost)

# --- 2. Load and Prepare Data ---
telco_data <- read_csv("data/WA_Fn-UseC_-Telco-Customer-Churn.csv") %>%
  na.omit() %>%
  mutate(Churn = as.factor(Churn))

# --- 3. Split the Data ---
set.seed(123)
telco_split <- initial_split(telco_data, prop = 0.75, strata = Churn)
train_data <- training(telco_split)
test_data  <- testing(telco_split)

# --- 4. Create the Recipe ---
# The recipe stays the same as before.
telco_recipe <- recipe(Churn ~ ., data = train_data) %>%
  update_role(customerID, new_role = "ID") %>%
  step_dummy(all_nominal_predictors()) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_smote(Churn)

# --- 5. DEFINE A TUNABLE MODEL ---
# Instead of fixed values, we use `tune()` to tell tidymodels
# that these are the hyperparameters we want to optimize.
xgb_spec_tuned <- boost_tree(
  trees = 1000,
  tree_depth = tune(),
  min_n = tune(),
  learn_rate = tune()
) %>%
  set_engine("xgboost") %>%
  set_mode("classification")

# --- 6. Create the Tunable Workflow ---
xgb_workflow_tuned <- workflow() %>%
  add_recipe(telco_recipe) %>%
  add_model(xgb_spec_tuned)

# --- 7. Set up for Tuning ---
# Create 10 cross-validation folds from the training data
set.seed(234)
telco_folds <- vfold_cv(train_data, v = 10)

# Define the metric we want to optimize: PR-AUC
pr_auc_metric <- metric_set(pr_auc)

# --- 8. RUN THE TUNING ---
# This is the main step. It will train and evaluate dozens of models.
# It may take several minutes to run!
set.seed(345)
xgb_res <- tune_grid(
  xgb_workflow_tuned,
  resamples = telco_folds,
  grid = 20, # Try 20 different hyperparameter combinations
  metrics = pr_auc_metric
)

# --- 9. Analyze Tuning Results ---
# Let's see which hyperparameters worked best
show_best(xgb_res, metric = "pr_auc")
autoplot(xgb_res) # A plot of the results

# --- 10. Finalize and Evaluate the Best Model ---
# Get the single best set of hyperparameters
best_xgb_params <- select_best(xgb_res, metric = "pr_auc")

# Update our workflow with these best settings
final_xgb_workflow <- finalize_workflow(xgb_workflow_tuned, best_xgb_params)

# Fit this final, best model on the full training data and
# evaluate it one last time on the unseen test data.
final_fit <- last_fit(final_xgb_workflow, telco_split)

# Collect and view the final performance metrics
final_metrics <- collect_metrics(final_fit)
print(final_metrics)
