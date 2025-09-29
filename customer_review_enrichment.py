# Install required libraries before running:
# pip install pandas nltk pyodbc sqlalchemy

import pandas as pd
import pyodbc
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer

# Ensure VADER lexicon is downloaded
nltk.download("vader_lexicon")

# -----------------------------
# Database Connection & Fetch
# -----------------------------
def get_reviews():
    connection_string = (
        "Driver={SQL Server};"
        "Server=BIPRAINSPIRON\\SQLEXPRESS;"
        "Database=PortfolioProject_MarketingAnalytics;"
        "Trusted_Connection=yes;"
    )
    with pyodbc.connect(connection_string) as conn:
        query = """
            SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText
            FROM fact_customer_reviews
        """
        return pd.read_sql(query, conn)

# Load data
reviews_df = get_reviews()

# -----------------------------
# Sentiment Analysis
# -----------------------------
analyzer = SentimentIntensityAnalyzer()

def get_score(text: str) -> float:
    return analyzer.polarity_scores(text)["compound"]

def classify_sentiment(score: float, rating: int) -> str:
    if score > 0.05:
        if rating >= 4:
            return "Positive"
        elif rating == 3:
            return "Mixed Positive"
        else:
            return "Mixed Negative"
    elif score < -0.05:
        if rating <= 2:
            return "Negative"
        elif rating == 3:
            return "Mixed Negative"
        else:
            return "Mixed Positive"
    else:
        if rating >= 4:
            return "Positive"
        elif rating <= 2:
            return "Negative"
        else:
            return "Neutral"

def bucketize(score: float) -> str:
    if score >= 0.5:
        return "0.5 to 1.0"
    elif 0 <= score < 0.5:
        return "0.0 to 0.49"
    elif -0.5 <= score < 0:
        return "-0.49 to 0.0"
    else:
        return "-1.0 to -0.5"

# -----------------------------
# Apply transformations
# -----------------------------
reviews_df["SentimentScore"] = reviews_df["ReviewText"].map(get_score)
reviews_df["SentimentCategory"] = reviews_df.apply(
    lambda r: classify_sentiment(r["SentimentScore"], r["Rating"]), axis=1
)
reviews_df["SentimentBucket"] = reviews_df["SentimentScore"].map(bucketize)

# -----------------------------
# Output
# -----------------------------
print(reviews_df.head())
reviews_df.to_csv("fact_customer_reviews_with_sentiment.csv", index=False)

