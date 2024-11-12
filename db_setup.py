"""
Setup script for the Sports Complex IMS database.
Run this before running setup.py!
"""

import mysql.connector

password = input("Enter password, but be warned as it will be visible: ")

# Establish connection to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",  # Replace with your MySQL username
    password=password  # Replace with your MySQL password
)

cursor = conn.cursor()

# Create database if it doesn't exist
cursor.execute("CREATE DATABASE IF NOT EXISTS sports_complex")
cursor.execute("USE sports_complex")

# Create ALL tables in queries/init_tables.sql
with open('queries/init_tables.sql', 'r', encoding='utf-8') as sql_file:
    sql_script = sql_file.read()
cursor.execute(sql_script, multi=True)
cursor.close()


# cursor = conn.cursor()
# # Fill all tables using script queries/fill_tables.sql
# with open('queries/fill_tables.sql', 'r') as fill_file:
#     fill_script = fill_file.read()
# cursor.execute(fill_script, multi=True)
# cursor.close()


conn.close()
print("Database setup complete.")
