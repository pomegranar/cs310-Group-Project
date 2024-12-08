"""
▞▀▖         ▐      ▞▀▖          ▜       
▚▄ ▛▀▖▞▀▖▙▀▖▜▀ ▞▀▘ ▌  ▞▀▖▛▚▀▖▛▀▖▐ ▞▀▖▚▗▘
▖ ▌▙▄▘▌ ▌▌  ▐ ▖▝▀▖ ▌ ▖▌ ▌▌▐ ▌▙▄▘▐ ▛▀ ▗▚ 
▝▀ ▌  ▝▀ ▘   ▀ ▀▀  ▝▀ ▝▀ ▘▝ ▘▌   ▘▝▀▘▘ ▘ 
▙▗▌                         ▐   ▞▀▖      ▐         
▌▘▌▝▀▖▛▀▖▝▀▖▞▀▌▞▀▖▛▚▀▖▞▀▖▛▀▖▜▀  ▚▄ ▌ ▌▞▀▘▜▀ ▞▀▖▛▚▀▖
▌ ▌▞▀▌▌ ▌▞▀▌▚▄▌▛▀ ▌▐ ▌▛▀ ▌ ▌▐ ▖ ▖ ▌▚▄▌▝▀▖▐ ▖▛▀ ▌▐ ▌
▘ ▘▝▀▘▘ ▘▝▀▘▗▄▘▝▀▘▘▝ ▘▝▀▘▘ ▘ ▀  ▝▀ ▗▄▘▀▀  ▀ ▝▀▘▘▝ ▘             
Run this to start the server.
"""

import os
import getpass
import mysql.connector
from flask import Flask, json, render_template, request, jsonify

# Prompt for MySQL password securely
password = getpass.getpass(prompt='Password: ', stream=None)

app = Flask(__name__)

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

def get_db_connection():
    """CONNECTING TO THE DATABASE."""
    return mysql.connector.connect(
        # host="localhost",
        user="root",
        password=password,
        database="sports"
    )

try:
    conn = get_db_connection()
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

print("\033[1;32mDatabase setup complete.\033[0m")





@app.route('/')
def index():
    """SERVING THE HOMEPAGE."""
    return render_template('index.html')


@app.route('/get_sports')
def get_sports():
    """API endpoint to get all sports."""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT name FROM sport ORDER BY name;")
    sports = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(sports)


@app.route('/get_equipment')
def get_equipment():
    # API endpoint to get equipment data for populating dropdowns.
    sport_name = request.args.get("sport", default=None)  # Get the sport filter if provided
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT s.name AS sport, e.name, e.number, e.equipment_id
        FROM equipment e
        JOIN sport s ON e.sport_id = s.sport_id
        LEFT OUTER JOIN active_borrower_items b ON e.equipment_id = b.equipment_id
        WHERE (b.borrow_when IS NULL)
    """
    params = []
    if sport_name and sport_name != "All":
        query += " AND s.name = %s"
        params.append(sport_name)

    query += " ORDER BY s.name;"
    cursor.execute(query, params)

    equipment = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(equipment)



@app.route('/checkout_equipment', methods=['POST'])
def checkout_equipment():
    """API endpoint for checking out equipment"""
    data = request.json

    card_number = data['card_number']
    equipment_id = data['equipment_id']

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            CALL checkout_equipment((SELECT user_id FROM user WHERE card_number = %s OR netid = %s),%s);
        """, (card_number, card_number, equipment_id))

        conn.commit()
        message = "Equipment checked out successfully."
        status = "success"

        # Log activity to CSV file
        with open('activity_log.csv', mode='a', encoding='utf-8') as file:
            file.write(
                f"Checkout,{card_number},{equipment_id}\n")
            
    except mysql.connector.Error as err:
        message = f"Error: {err.msg}"
        status = "error"
        print(f"Error: {err.msg}")

    cursor.close()
    conn.close()

    return jsonify({"message": message, "status": status})


@app.route('/get_borrowed_equipment')
def get_borrowed_equipment():
    """API endpoint to fetch currently borrowed equipment"""
    card_number = request.args.get('card_number')
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get borrowed equipment
        cursor.execute("select * from active_borrower_items where (card_number = %s OR netid = %s)", (card_number,card_number,))
        borrowed_equipment = cursor.fetchall()
    finally:
        cursor.close()
        conn.close()

    return jsonify(borrowed_equipment)


@app.route('/check_in_equipment', methods=['POST'])
def check_in_equipment():
    """API endpoint to check in selected equipment"""
    data = request.json
    card_number = data['card_number']
    equipment_ids = data['equipment_ids']  # This is a list of equipment IDs

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("CALL check_in_equipment((SELECT user_id FROM user WHERE (card_number = %s OR netid = %s)), %s)", 
                       (card_number,card_number, json.dumps(equipment_ids)))

        conn.commit()
        message = "Equipments successfully checked in."
        status = "success"

    except Exception as err:
        message = f"Error: {err}"
        status = "error"
        print(err)

    cursor.close()
    conn.close()

    return jsonify({"message": message, "status": status})


@app.route('/get_facility')
def get_facility():
    """API endpoint to get facilities data (for populating the dropdown)"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT facility_id, name, floor, reservable
        FROM facility
        WHERE reservable = TRUE;
    """)

    facilities = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(facilities)


@app.route('/reserve')
def reserve():
    """Renders the reservation page"""
    return render_template('reserve.html')

@app.route('/checkin')
def checkin():
    return render_template('checkin.html')


@app.route('/reserve_facility', methods=['POST'])
def reserve_facility():
    """API endpoint for reserving a facility"""
    data = request.json

    if not all(key in data for key in ['card_number', 'facility_id', 'reserve_date', 'start_time', 'end_time']):
        return jsonify({"message": "Invalid request data.", "status": "error"}), 400

    card_number = data['card_number']
    facility_id = data['facility_id']
    reserve_date = data['reserve_date']
    start_time = data['start_time']
    end_time = data['end_time']

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            CALL reserve_facility(
                (SELECT user_id FROM user WHERE card_number = %s OR netid = %s),
                %s, %s, %s, %s
            );
        """, (card_number, card_number, facility_id, reserve_date, start_time, end_time))

        conn.commit()
        message = "Reservation successful."
        status = "success"

        # Log activity to CSV file
        with open('activity_log.csv', mode='a', encoding='utf-8') as file:
            file.write(
                f"Reservation,{card_number},{facility_id}\n")

    except mysql.connector.Error as err:
        message = f"Error: {err.msg}"
        status = "error"
        print(f"Error: {err.msg}")

    cursor.close()
    conn.close()

    return jsonify({"message": message, "status": status})



if __name__ == '__main__':
    app.run(debug=True)
