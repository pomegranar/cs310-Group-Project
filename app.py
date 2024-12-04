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


@app.route('/get_equipment')
def get_equipment():
    """API endpoint to get equipment data (for populating dropdowns)"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT s.name AS sport, e.name, e.number, e.equipment_id
        FROM equipment e
        JOIN sport s ON e.sport_id = s.sport_id
        LEFT OUTER JOIN borrowed b ON e.equipment_id = b.equipment_id
        WHERE b.equipment_id IS NULL OR b.returned_on IS NOT NULL;
        """)

    equipment = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(equipment)


@app.route('/checkout_equipment', methods=['POST'])
def checkout_equipment():
    # TODO: Add check for penalties!!
    """API endpoint for checking out equipment"""
    data = request.json

    card_number = data['card_number']
    equipment_id = data['equipment_id']

    conn = get_db_connection()

    cursor = conn.cursor()

    # Add to borrowed table with checkout details
    cursor.execute("""
        INSERT INTO borrowed (user_id, equipment_id)
        VALUES ((SELECT user_id FROM user WHERE card_number = %s), %s);
        """, (card_number, equipment_id))

    if cursor.rowcount == 0:
        message = "Equipment already checked out, or invalid."
        status = "error"

    else:
        conn.commit()
        message = "Equipment checked out successfully."
        status = "success"

        # Log activity to CSV file
        with open('activity_log.csv', mode='a', encoding='utf-8') as file:
            file.write(
                f"Checkout,Card number: {card_number},Equipment ID: {equipment_id}\n")

    cursor.close()

    conn.close()

    return jsonify({"message": message, "status": status})


if __name__ == '__main__':
    app.run(debug=True)
