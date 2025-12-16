import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import streamlit as st
from dbhelper import DB

db = DB()
df = db.load_data()


st.sidebar.title("Global Layoff Dashboard")

option = st.sidebar.selectbox("OPTIONS",["Overview","Industry & Stage Impact","Funding & Layoff Severity","Time Trends","Key Takeaways"])

if option == 'Overview':
    st.title("Overview")
    "---"

    st.markdown(
        """
        This dashboard presents an exploratory analysis of global layoff trends
        across industries, company stages, funding levels, and time.
        The goal is to understand where layoffs are concentrated and how severe they are.

        ---
        """
    )


    total_layoffs = int(df['total_laid_off'].sum())
    total_companies = df['company'].nunique()
    total_countries = df['country'].nunique()
    df['date'] = pd.to_datetime(df['date'])
    start_year = int (df['date'].dt.year.min())
    end_year = int(df['date'].dt.year.max())

    col1, col2, col3, col4 = st.columns(4)

    col1.metric("Total Layoffs", total_layoffs)
    col2.metric("Total Layoffs", total_companies)
    col3.metric("Total Country", total_countries)
    col4.metric("Time Period",f"{start_year}-{end_year}")

    st.markdown(
        """
        --- 
        **Note:** The data is primarily focused on reported layoffs and may be
        biased toward regions with higher reporting availability.
        """
    )

if option == "Industry & Stage Impact":
    st.title("Industry & Stage Impact")
    "---"

    st.markdown(
        "This section shows which industries and company stages contribute the most to total layoffs."
    )

    industry_layoffs = (
        df.groupby("industry", dropna=True)["total_laid_off"].sum().sort_values(ascending=False).head(10).reset_index()
    )

    st.subheader("Total Layoffs by Industry (Top 10)")

    st.bar_chart(
        industry_layoffs,x='industry'
    )

    st.markdown(
        "Consumer, Retail, and Transportation industries account for the largest total layoffs, "
        "indicating high-impact workforce reductions in these sectors."
    )

    "---"

    stage_layoffs = (
        df.groupby("stage", dropna=True)["total_laid_off"].sum().sort_values(ascending=False).head(10).reset_index()
    )

    st.subheader("Total Layoffs by Company Stage")

    st.bar_chart(stage_layoffs,x='stage')

    st.markdown(
        "Post-IPO companies dominate total layoffs, showing that large scale restructuring "
        "is mainly driven by mature companies rather than early-stage startups."
    )

if option == 'Funding & Layoff Severity':
    st.title("Funding & Layoff Severity")
    
    "---"

    st.markdown(
        "This section shows how funding levels relate to the severity of layoffs, "
        "measured as the average percentage of employees laid off."
    )

    def funding_category(x):
        if pd.isna(x):
            return "Unknown"
        elif x <= 10:
            return "0–10M"
        elif x <= 50:
            return "11–50M"
        elif x <= 200:
            return "51–200M"
        elif x <= 500:
            return "201–500M"
        else:
            return ">500M"
    
    df_severity = df[df['funds_raised_millions'].notna()].copy()
    
    df_severity['funding_buckets'] = df['funds_raised_millions'].apply(funding_category)
    
    funding_buckets_layoff = (
        df_severity
        .groupby("funding_buckets")["percentage_laid_off"]
        .mean()
        .mul(100)
        .round(2)
        .reindex(["0–10M", "11–50M", "51–200M", "201–500M", ">500M", "Unknown"])
        .reset_index()
    )


    st.subheader("Average Percentage of Laid Off by Funding Level")
    st.bar_chart(funding_buckets_layoff, x="funding_buckets", y="percentage_laid_off")

    st.markdown(
        "Layoff severity decreases as funding increases. "
        "Low funded companies tend to lay off a much larger share of their workers, "
        "often indicating shutdowns, while highly funded companies usually make smaller, "
        "more controlled cuts."
    )

