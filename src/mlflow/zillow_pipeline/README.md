# MLOps / Zillow Project

## Overview

This project focuses on building a time series forecasting model using the Zillow Observed Rent Index (ZORI) data. By leveraging wavelet-based techniques, we aim to enhance forecasting accuracy and implement MLOps practices for efficient model deployment and monitoring.

## Zillow Observed Rent Index (ZORI)

The Zillow Observed Rent Index (ZORI) measures changes in asking rents over time, controlling for variations in the quality of available rental stock. Unlike other rental price measures, ZORI accounts for the dynamic nature of rental listings, providing a more accurate reflection of market-based rent movements. :contentReference[oaicite:0]{index=0}

## Time Series Forecasting with Wavelets

Wavelet transforms decompose a time series into time-dependent frequency components, effectively capturing seasonalities with time-varying periods and intensities. Incorporating wavelet transforms into forecasting methods can improve their quality by modeling both trend and seasonality more accurately. :contentReference[oaicite:1]{index=1}

## Methodology

1. **Data Acquisition**:
   - Extract ZORI data from Zillow's public datasets. :contentReference[oaicite:2]{index=2}

2. **Data Preprocessing**:
   - Handle missing values and outliers.
   - Normalize or standardize the data as needed.

3. **Wavelet Decomposition**:
   - Apply wavelet transform to decompose the time series into components representing different frequency bands.

4. **Model Building**:
   - Combine wavelet-transformed features with traditional forecasting models (e.g., ARIMA) or machine learning models (e.g., neural networks) to capture both linear and non-linear patterns.

5. **Model Evaluation**:
   - Assess model performance using appropriate metrics (e.g., RMSE, MAE) and validate with a test dataset.

6. **MLOps Integration**:
   - Implement continuous integration and deployment pipelines.
   - Set up monitoring and logging for model performance in a production environment.

## Dashboards

We utilize dbt to extract forecasting information from Zillow's public data.

### Metabase Resources

- [Transformed ZORI Value, Boulder](http://localhost:3000/question/2-stg-zordi-sfrcondo-average-of-zordi-value-grouped-by-regionname-and-date-filtered-by-statename-is-co-regiontype-is-msa-date-starts-with-2024-and-regionname-is-boulder-co)

## Resources

- [Methodology: Zillow Observed Rent Index (ZORI)](https://www.zillow.com/research/methodology-zori-repeat-rent-27092/)
- [Housing Data - Zillow Research](https://www.zillow.com/research/data/)
- [Time Series Forecasting with Wavelets - GitHub Repository](https://github.com/samluxenberg1/Time-Series-Forecasting-with-Wavelets)
- [Using Wavelets for Time Series Forecasting: Does it Pay Off?](https://www.econstor.eu/bitstream/10419/36698/1/626829879.pdf)
