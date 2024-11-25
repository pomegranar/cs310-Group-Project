"""
Setup script for the Sports Complex IMS database.
Run this before running setup.py!
"""

import getpass
import mysql.connector

password = getpass.getpass(prompt='Password: ', stream=None)

# Establish connection to MySQL
conn = mysql.connector.connect(
    host="localhost",
    user="root",  # Replace with your MySQL username
    password=password  # Replace with your MySQL password
)

cursor = conn.cursor()

with open('queries/new_schema.sql', 'r', encoding='utf-8') as schema:
    sql_script = schema.read()
cursor.execute(sql_script, multi=True)
cursor.close()


cursor = conn.cursor()

with open('queries/fill_data.sql', 'r', encoding='utf-8') as schema:
    sql_script = schema.read()
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
