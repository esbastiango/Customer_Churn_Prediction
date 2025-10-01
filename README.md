# Proactive Customer Churn Intervention with XGBoost and R

This project builds and deploys a classification model using XGBoost that predicts the probability of a telecom customer churning and provides actionable explanations for high-risk predictions.

---

### 💼 Business Problem & Value Proposition

Customer attrition is a critical business metric; retaining an existing customer is far more cost-effective than acquiring a new one. This project moves beyond a reactive strategy by creating a system to proactively identify customers at high risk of churning.

The model doesn't just predict *who* will churn, but provides explanations for *why* they are at risk. This allows a retention team to make targeted, personalized interventions—for example, offering a service upgrade to a customer frustrated with tech support, or a discount to someone flagged for high monthly charges. The tangible business value is realized through reduced churn, lower retention costs, and improved customer lifetime value.

---

### 🚀 Live API Endpoints (Demonstration)

The final model is deployed as a REST API, ready for integration into a production environment. Here are the available endpoints:

* **`/predict`**: Accepts new customer data in JSON format and returns the probability of churn.
* **`/explain`**: Accepts data for a single customer and returns its corresponding SHAP values, providing on-demand model transparency.

**Example `curl` command to get a prediction:**
```bash
# (Example command - you would replace with your actual API URL and data)
curl -X POST "[http://127.0.0.1:8000/predict](http://127.0.0.1:8000/predict)" \
-H "Content-Type: application/json" \
-d '{"gender": "Female", "SeniorCitizen": 0, "Partner": "Yes", ...}'
```

---

### ## 📊 Key Results & Visualizations

The final tuned XGBoost model significantly outperforms the naive baseline, demonstrating a strong ability to identify at-risk customers while maintaining high confidence in its predictions.

| Model                   | ROC-AUC | PR-AUC | Recall | Precision |
| ----------------------- | ------- | ------ | ------ | --------- |
| Baseline (Majority Class) | 0.500   | 0.266  | 0.000  | NA        |
| **Tuned XGBoost** | **0.859** | **0.678** | **0.775** | **0.904** |


**Key Visualizations:**

1.  **SHAP Summary Plot**: Shows the most important features driving churn predictions across all customers.
2.  **SHAP Waterfall Plot**: Decomposes a single high-risk prediction, showing exactly how each feature contributed to the final score.


---

### ## 🛠️ Operational AI Skills Demonstrated

This project was engineered to reflect the best practices of operationalizing AI, ensuring the final product is reliable, safe, and efficient.

* **1. Instrumentation & Monitoring** 📡
    * The deployed API is structured for robust logging. Each call to the `/predict` endpoint can log the input features, the model's output probability, and the prediction latency, making the system observable and easy to debug.

* **2. Evaluation** ✅
    * A rigorous, offline evaluation protocol was used. The model was trained and validated on a split dataset and its performance measured against a held-out test set. The primary metric, PR-AUC, was chosen specifically to handle the known class imbalance in the data, ensuring the model is optimized for the correct business outcome.

* **3. Safety & Quality Assurance** 🛡️
    * The system includes inherent safety measures. Personally Identifiable Information (PII) is handled by assigning `customerID` an "ID" role in the recipe, preventing it from being used as a predictor. The API can be layered with input validation to reject malformed requests and content filters on outputs to prevent unexpected behavior.

* **4. Reliability** 💪
    * The model is deployed using `vetiver` and `plumber`, a production-grade stack for serving R models. This architecture ensures resilience. Reliability patterns like caching for frequent requests or retries with exponential backoff can be easily added to the API service to handle transient failures gracefully.

* **5. Lifecycle Management** 🔄
    * The project is designed for long-term maintenance. By continuously monitoring the model's PR-AUC on new, incoming data, a "retraining trigger" can be established. If performance degrades due to concept or data drift (e.g., PR-AUC drops below a set threshold), an automated retraining and deployment pipeline can be initiated to ensure the model remains accurate over time.

* **6. Cost & Performance Optimization** 💰
    * Efficiency is a core component of the design. XGBoost was chosen for its high performance on tabular data. Deploying the model as an on-demand API is highly cost-effective, as it avoids the need to run batch predictions on the entire customer base, consuming compute resources only when a prediction is requested.

* **7. Agents & Workflows** 🤖
    * This API is designed to be a "tool" in a larger, orchestrated business workflow. For instance, a CRM system could act as an "agent" that automatically calls the `/predict` endpoint for a customer after a support call. Based on the returned churn risk, the agent could then decide on a follow-up action, such as alerting a retention specialist or automatically sending a targeted offer.

---

### ## 💻 Tech Stack

* **Modeling**: `tidymodels`, `recipes`, `parsnip`, `xgboost`
* **Imbalance Handling**: `themis` (for SMOTE) 
* **Explainability**: `shapviz` (for SHAP values) 
* **Deployment**: `vetiver`, `plumber` 
* **Core R**: `dplyr`, `ggplot2` 

---

### ## 🔬 Methodology

1.  **EDA & Baseline**: The Telco dataset was loaded and explored, confirming a churn rate of ~27%. A naive baseline model (always predicting "No Churn") was established, which has an accuracy of ~73% but a recall of 0 for finding churners.
2.  **Preprocessing**: A `tidymodels` recipe was built to handle data preparation. This included dummy coding for categorical variables, normalizing numeric predictors, and applying SMOTE to synthetically balance the training data, which is a crucial step for handling class imbalance.
3.  **Model Training**: An initial XGBoost model was defined and bundled with the recipe into a `workflow` object.
4.  **Hyperparameter Tuning**: The model was optimized using 10-fold cross-validation. `tune_grid` systematically tested 20 different hyperparameter combinations to find the set that maximized the PR-AUC metric.
5.  **Finalization & Evaluation**: The workflow was finalized with the best hyperparameters and fit on the entire training set. [cite: 42, 43] Performance was then measured on the held-out test set to get a final, unbiased estimate of its effectiveness.
6.  **Explainability**: SHAP values were calculated for the test set to provide both global feature importance and local, per-prediction explanations, turning the model from a "black box" into an interpretable tool.

---

### ## 🚀 How to Run

**1. Setup the Environment**

This project uses `renv` for dependency management. To restore the environment, run:
```R
# Install renv if you haven't already
# install.packages("renv")

# Restore the project's dependencies
renv::restore()
```
If not using `renv`, manually install the packages listed in the **Tech Stack** section.

**2. Run the Analysis**

The analysis is broken into scripts that should be run in order:
```bash
# 1. Exploratory Data Analysis and Baseline
Rscript 01_initial_eda.R

# 2. Train the first, untuned model
Rscript 02_first_model.R

# 3. Tune hyperparameters and train the final model
Rscript 03_tuned_model.R
```

**3. Launch the API**

The final model can be served locally using the `plumber` API script.
```R
# In an R session, run:
plumber::pr("api/plumber.R") %>%
  plumber::pr_run(port = 8000)
```
The API will now be available at `http://127.0.0.1:8000`.
