"""
Setup script for the Sports Complex database.
Run this before running setup.py!
"""

import getpass
import mysql.connector

# Prompt for MySQL password securely
password = getpass.getpass(prompt="Password: ", stream=None)

try:
    # Establish connection to MySQL
    conn = mysql.connector.connect(
        host="localhost",
        user="root",  # Replace with your MySQL username
        password=password  # Replace with your MySQL password
    )
    conn.autocommit = True  # Ensure changes are committed automatically

    cursor = conn.cursor()

    # Execute schema setup script
    with open("queries/new_schema.sql", "r", encoding="utf-8") as schema_file:
        schema_script = schema_file.read()
    cursor.execute(schema_script, multi=True)
    print("Database schema setup complete.")

    try:
        with open("queries/fill_data.sql", "r", encoding="utf-8") as data_file:
            data_script = data_file.read()

        print("Executing fill_data.sql...")
        for statement in data_script.split(";"):
            statement = statement.strip()
            if statement:  # Skip empty statements
                try:
                    cursor.execute(statement)
                except mysql.connector.Error as err:
                    print(f"Error executing statement: {statement}\n{err}")
    except mysql.connector.Error as err:
        print(f"Error executing fill_data.sql: {err}")
    except FileNotFoundError:
        print("Error: fill_data.sql file not found.")
    except Exception as e:
        print(f"Unexpected error: {e}")


except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    # Always close the cursor and connection
    if cursor:
        cursor.close()
    if conn:
        conn.close()

print("Database setup complete.")
