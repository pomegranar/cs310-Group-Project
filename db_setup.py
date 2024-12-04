"""
Setup script for the Sports Complex database.
Run this before running setup.py!
"""

import getpass
import os
import mysql.connector

# Prompt for MySQL password securely
password = getpass.getpass(prompt="Password: ", stream=None)


def execute_script(cursor, script):
    """Execute a multi-statement SQL script with support for custom delimiters."""
    delimiter = ";"  # Default delimiter
    statements = []

    for line in script.splitlines():
        line = line.strip()

        if line.startswith("DELIMITER"):
            parts = line.split()
            if len(parts) == 2:
                delimiter = parts[1]
            continue

        statements.append(line)

        if line.endswith(delimiter):
            statement = "\n".join(statements).rstrip(delimiter).strip()
            if statement:  # Skip empty statements
                cursor.execute(statement, multi=False)
            statements = []  # Reset for the next statement

    if statements:
        statement = "\n".join(statements).rstrip(delimiter).strip()
        if statement:
            cursor.execute(statement, multi=False)


try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",  # Replace with your MySQL username
        password=password
    )
    conn.autocommit = True

    cursor = conn.cursor()

    queries_folder = "queries"
    sql_files = sorted(f for f in os.listdir(
        queries_folder) if f.endswith(".sql"))

    for sql_file in sql_files:
        file_path = os.path.join(queries_folder, sql_file)

        print(f"Executing {sql_file}...")

        with open(file_path, "r", encoding="utf-8") as file:
            sql_script = file.read()

        execute_script(cursor, sql_script)

        print(f"{sql_file} executed successfully.")

except mysql.connector.Error as err:
    print(f"Database connection error: {err}")
except Exception as e:
    print(f"Unexpected error: {e}")
finally:
    if 'cursor' in locals() and cursor:
        cursor.close()
    if 'conn' in locals() and conn:
        conn.close()

print("Database setup complete.")
