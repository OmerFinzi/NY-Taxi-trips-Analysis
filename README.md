# 🗽 NY Taxi Trips Analysis

This project focuses on analyzing real-world NYC yellow taxi data from 2022, using SQL and publicly available datasets. The main objective was to uncover patterns and insights in ride behavior across different time periods and geographic zones within New York City.

## 📊 Dataset
The analysis was based on the following dataset:

- `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022`  
  (Public BigQuery dataset provided by Google)

In addition, a local CSV file (`taxi_zone_lookup.csv`) was used to enrich the data with meaningful zone names and boroughs.

## 🛠️ Tools & Technologies
- SQL (Google BigQuery dialect)
- Git & GitHub for version control
- CSV for supplementary lookup data

## 🧠 Key Questions Explored
- What are the busiest pickup and dropoff zones in NYC?
- How does ride frequency vary by day of the week and hour?
- Which boroughs generate the most taxi traffic?
- What is the average fare across different areas?

## 📂 Project Structure
- `NY_Taxi_Analysis.sql`: Contains all SQL queries used to extract, join, and analyze the data
- `taxi_zone_lookup.csv`: Lookup file mapping location IDs to zone names and boroughs

## 🧩 Key Insights
- **Midtown Manhattan** consistently ranked among the top pickup and dropoff zones.
- Peak taxi activity occurs during **evening hours** and on **weekends**.
- Certain outer boroughs (e.g., Queens) show high trip volume near airports.
- Fare amounts vary greatly depending on time of day and trip length.

## 🚀 Getting Started
You can explore the queries directly in BigQuery using the dataset mentioned above, or replicate the logic using your own taxi data.

## 📎 Link to Dataset
You can explore the dataset here:  
[BigQuery – NYC Taxi Trips](https://console.cloud.google.com/bigquery?project=bigquery-public-data&d=bigquery-public-data&p=bigquery-public-data&t=tlc_yellow_trips_2022&page=table)

---

Feel free to fork, modify, or use this as inspiration for your own analysis!
