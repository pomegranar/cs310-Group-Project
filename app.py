"""
Run this to start the server.
Try not to edit this.
"""

import getpass
import mysql.connector
from flask import Flask, render_template, request, jsonify

password = getpass.getpass(prompt='Password: ', stream=None)

app = Flask(__name__)


def get_db_connection():
    """CONNECTING TO THE DATABASE."""
    return mysql.connector.connect(
        # host="localhost",
        user="root",
        password=password,
        database="sports"
    )


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
        LEFT OUTER JOIN borrowed b ON e.equipment_id = b.equipment_id
        WHERE (b.equipment_id IS NULL OR b.returned_on IS NOT NULL)
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
    # TODO: Turn this into a procedure to allow checks for penalties and maintain cardinality. This would also prevent having to constantly reload the server.
    """API endpoint for checking out equipment"""
    data = request.json

    card_number = data['card_number']
    equipment_id = data['equipment_id']

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            CALL checkout_equipment(
                (SELECT user_id FROM user WHERE card_number = %s OR netid = %s),%s
            );
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
