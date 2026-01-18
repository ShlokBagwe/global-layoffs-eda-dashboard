import pandas as pd
import streamlit as st
from dbhelper import DB
import matplotlib.pyplot as plt
import seaborn as sns

db = DB()
df = db.load_data()


st.sidebar.title("Global Layoff Dashboard")

option = st.sidebar.selectbox("OPTIONS",["Overview","Industry & Stage Impact","Funding & Layoff Severity","Time Trends","Multivariate Insights","Key Takeaways"])

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
    col2.metric("Total Companies", total_companies)
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
        "indicating high-impact workers reductions in these sectors."
    )

    "---"

    stage_layoffs = (
        df.groupby("stage", dropna=True)["total_laid_off"].sum().sort_values(ascending=False).head(10).reset_index()
    )

    st.subheader("Total Layoffs by Company Stage")

    st.bar_chart(stage_layoffs,x='stage')

    st.markdown(
        "Post-IPO companies dominate total layoffs, showing that large scale restructuring "
        "is mainly driven by mature companies rather than early stage startups."
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
    st.text("Note: Fundings are in dollars($)")
    st.bar_chart(funding_buckets_layoff, x="funding_buckets", y="percentage_laid_off")

    st.markdown(
        "Layoff severity decreases as funding increases. "
        "Low funded companies tend to lay off a much larger share of their workers, "
        "often indicating shutdowns, while highly funded companies usually make smaller, "
        "more controlled cuts."
    )


if option == "Time Trends":
    st.title("Layoff Trends Over Time")

    st.markdown(
        "This section shows how layoff activity changes over time. "
        "It helps identify periods when layoffs increased sharply and whether layoffs "
        "occur in distinct waves or steady patterns."
    )

    df["date"] = pd.to_datetime(df["date"])

    df_time = df.dropna(subset=["date", "total_laid_off"]).copy()
    df_time["year"] = df_time["date"].dt.year.astype(str)
    df_time["month_year"] = df_time["date"].dt.to_period("M").astype(str)

    year_layoff = (
        df_time.groupby("year")["total_laid_off"]
        .sum()
        .reset_index()
    )

    st.subheader("Total Layoffs by Year")
    st.line_chart(year_layoff, x="year", y="total_laid_off")

    st.markdown(
        "Layoffs peaked in 2022 and remained high into early 2023. "
        "In contrast, 2021 shows very low layoff activity."
    )

    "---"

    month_layoff = (
        df_time.groupby("month_year")["total_laid_off"]
        .sum()
        .reset_index()
    )

    st.subheader("Monthly Layoff Trends")
    st.line_chart(month_layoff, x="month_year", y="total_laid_off")

    st.markdown(
        "Monthly trends show that layoffs happen in clear waves rather than evenly over time. "
        "Major spikes are visible during early 2020, mid to late 2022, and early 2023."
    )



if option == "Multivariate Insights":
    st.title("Multivariate Insights")

    st.markdown(
        "This section combines multiple factors to explain why certain layoff patterns "
        "appear across industries, company stages, and funding levels."
    )

    st.divider()


    st.subheader("Industry and Stage Impact on Total Layoffs")

    df_multi_1 = df[df["total_laid_off"].notna()].copy()

    industry_stage_layoffs = (
        df_multi_1
        .groupby(["industry", "stage"])["total_laid_off"]
        .sum()
        .reset_index()
        .sort_values("total_laid_off", ascending=False)
        .head(10)
    )


    industry_stage_layoffs["industry_stage"] = (
        industry_stage_layoffs["industry"] + " | " + industry_stage_layoffs["stage"]
    )

    st.bar_chart(
        industry_stage_layoffs,
        x="industry_stage",
        y="total_laid_off"
    )

    st.markdown(
        "Large scale layoffs are mainly driven by **Post-IPO companies across multiple industries**, "
        "especially Consumer, Retail, and Transportation. This shows that layoffs are largely the result "
        "of restructuring in mature companies rather than early stage startup failures."
    )

    "---"


    st.subheader("Stage, Funding, and Layoff Severity")

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

    df_multi_2 = df[df["percentage_laid_off"].notna()].copy()
    df_multi_2["funding_bucket"] = df_multi_2["funds_raised_millions"].apply(funding_category)



    stage_funding_severity = (
        df_multi_2
        .groupby(["stage", "funding_bucket"])["percentage_laid_off"]
        .mean()
        .mul(100)
        .round(2)
        .reset_index()
    )

    stage_funding_severity = stage_funding_severity[
        stage_funding_severity["stage"].isin(["Seed", "Series A", "Series B", "Post-IPO"])
    ]

    fig, ax = plt.subplots(figsize=(10, 6))

    sns.barplot(
        data = stage_funding_severity,
        x = "funding_bucket",
        y = "percentage_laid_off",
        hue = "stage",
        ax=ax
    )
    
    ax.grid(axis='y', which='major', alpha=0.9)
    
    plt.title("Stage, Funding, and Layoff Severity")
    plt.xlabel("Fundings($)")
    plt.ylabel("Layoff(%)")
    plt.legend(loc='best')
    st.pyplot(fig)

    st.markdown(
        "Early stage and low funded companies experience the most severe layoffs, often cutting a large "
        "portion of their workers. Post-IPO and well funded companies tend to have much "
        "lower layoff percentages."
    )




if option == "Key Takeaways":
    st.title("Key Takeaways")

    st.markdown(
        "This section summarizes the main insights from the analysis and highlights "
        "the overall patterns observed in global layoff trends."
    )

    st.markdown("### Main Insights")

    st.markdown(
        """
        - Most total layoffs are driven by **Post-IPO and mature companies**, not early-stage startups.
        - Industries such as **Consumer, Retail, Transportation, and Finance** contribute the largest share of layoffs.
        - **Funding level strongly affects layoff severity**: low-funded companies tend to lay off a much larger percentage of their workers.
        - Highly funded companies usually conduct **smaller, controlled layoffs**, indicating restructuring rather than shutdowns.
        - Layoffs occur in **clear time-based waves**, with major peaks in 2022 and continued impact into early 2023.
        - The dataset is **heavily dominated by U.S.-based companies**, which should be considered when interpreting global trends.
        """
    )

    "---"

    st.markdown(
        "Overall, the analysis shows that layoffs are influenced by multiple factors working together, "
        "including company stage, funding, industry, and broader economic conditions."
    )