# Global Layoffs EDA Dashboard

## Project Overview

This project analyzes global layoff trends using **SQL based Exploratory Data Analysis (EDA)** and presents key insights through an **interactive Streamlit dashboard**. The goal of the project is to understand **where layoffs are concentrated, how severe they are, and which factors influence them**, such as industry, company stage, funding level, and time.

The analysis was first performed in **MySQL**, where the raw dataset was cleaned and prepared. The cleaned data is then fetched from the database and used in a Streamlit dashboard to visually summarize the most important findings.

This project focuses on **data understanding and storytelling**, not prediction or machine learning.

---

## Streamlit - Dashboard
- link: https://shlokbagwe-global-layoffs-eda-dashboard-app-wlncob.streamlit.app/

---

## Dataset

* Source: Global layoffs dataset (publicly available)
* Time range: Multiple years (including COVID and post-COVID period)
* Key columns:

  * company
  * industry
  * stage
  * country
  * total_laid_off
  * percentage_laid_off
  * funds_raised_millions
  * date

The raw CSV file is included only for reference.
All analysis and visualization use the **cleaned version stored in MySQL**.

---

## Data Cleaning (SQL)

All data cleaning was performed in **MySQL**, not in Python.
This ensures a single source of truth for both analysis and visualization.

Cleaning steps included:

* Removing duplicate records using window functions
* Standardizing industry and country names
* Handling missing values logically
* Converting date columns to proper date format
* Removing rows with no meaningful layoff information
* Validating numeric ranges

The SQL queries used for cleaning and analysis are included in this repository.

---

## Exploratory Data Analysis

The EDA was performed in multiple phases:

### Phase 1: Univariate Analysis

* Distribution of total layoffs
* Distribution of layoff severity (percentage laid off)
* Funding distribution and outliers
* Industry, stage, and country frequencies

### Phase 2: Bivariate Analysis

* Industry × total layoffs
* Stage × total layoffs
* Country × total layoffs
* Funding × layoff severity
* Date × total layoffs (yearly and monthly trends)

### Phase 3: Multivariate Analysis

Focused on explaining *why* certain patterns appear:

* **Industry × Stage × Total Layoffs**
* **Stage × Funding × Percentage Laid Off**

These analyses revealed that:

* Large job losses are driven mainly by Post-IPO companies across industries
* Early-stage and low-funded companies experience the most severe layoffs
* Funding reduces layoff severity but does not prevent layoffs
* Layoffs occur in clear time-based waves

---

## Streamlit Dashboard

The Streamlit dashboard is designed to **summarize insights**, not replicate the full EDA.

### Dashboard Pages

1. **Overview**
   High-level KPIs and project context

2. **Industry & Stage Impact**
   Which industries and company stages contribute most to total layoffs

3. **Funding & Layoff Severity**
   How funding level affects the percentage of workforce laid off

4. **Time Trends**
   Yearly and monthly layoff patterns

5. **Multivariate Insights**
   Combined analysis of:

   * Industry × Stage × Total Layoffs
   * Stage × Funding × Layoff Severity

6. **Key Takeaways**
   Short summary of the most important conclusions

The dashboard intentionally avoids clutter, raw tables, and excessive filters to keep the story clear.

---

## Tech Stack

* **SQL**: MySQL (data cleaning & EDA)
* **Python**: pandas
* **Visualization**: Matplot, Seaborn, Streamlit
* **Database Connector**: mysql-connector-python

---

## Repository Structure

```
global-layoffs-eda-dashboard/
│
├── sql/
│   ├── layoff_data_cleaning.sql
|   └── lauoff_eda.sql
│   
├── README.md
├── app.py
├── dbhelper.py
├── layoffs.csv
└── requirements.txt
```

---

## How to Run the Project

1. Clone the repository
2. Set up the MySQL database and import the cleaned table
3. Update database credentials in the Streamlit app
4. Install dependencies:

   ```
   pip install -r requirements.txt
   ```
5. Run the app:

   ```
   streamlit run streamlit_app.py
   ```

---

## Key Learnings

* SQL is powerful for structured EDA and data cleaning
* Impact (total layoffs) and severity (percentage laid off) tell different stories
* Funding level strongly influences how severe layoffs are
* Mature companies drive large job losses, while small companies suffer the most severe cuts
* Dashboards should summarize insights, not replace analysis

---


## Final Note

This project is intended as a **learning focused data analysis project**, demonstrating how SQL based EDA can be combined with simple visualization to extract meaningful insights from real-world data.


