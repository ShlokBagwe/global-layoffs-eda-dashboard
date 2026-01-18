import mysql.connector
import os
import pandas as pd

class DB:

    def __init__(self):
        try:
            # Try to import streamlit for secrets, fallback to environment variables
            try:
                import streamlit as st
                host = st.secrets.get("DB_HOST", os.environ.get('DB_HOST'))
                user = st.secrets.get("DB_USER", os.environ.get('DB_USER'))
                password = st.secrets.get("DB_PASSWORD", os.environ.get('DB_PASSWORD'))
            except (ImportError, FileNotFoundError):
                host = os.environ.get('DB_HOST')
                user = os.environ.get('DB_USER')
                password = os.environ.get('DB_PASSWORD')
            
            self.conn = mysql.connector.connect(
                host = host,
                user = user,
                password = password,
                database = 'world_layoff'
            )
            self.mycursor = self.conn.cursor()
            print("Connection established" if self.conn.is_connected() 
            else "Connection not established")

        except Exception as e:
            print(f"Connection Error:{e}")
            self.conn= None
            self.mycursor = None


    def load_data(self):
        if self.conn is None:
            raise Exception("Database connection not established. Please check your environment variables.")
        query = "SELECT * FROM layoffs"
        return pd.read_sql(query, self.conn)


if __name__ == "__main__":
    db = DB()
    