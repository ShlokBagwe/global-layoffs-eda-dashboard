import mysql.connector
import os
import pandas as pd

class DB:

    def __init__(self):
        try:
            self.conn = mysql.connector.connect(
                host = os.environ.get('DB_HOST'),
                user = os.environ.get('DB_USER'),
                password = os.environ.get('DB_PASSWORD'),
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
    