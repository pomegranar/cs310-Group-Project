"""
Run this to start the server.
Try not to edit this.
"""

import getpass
# import json
import mysql.connector
from flask import Flask, render_template, request, jsonify

password = getpass.getpass(prompt='Password: ', stream=None)

app = Flask(__name__)


def get_db_connection():
    """CONNECTING TO THE DATABASE."""
    return mysql.connector.connect(
        host="localhost",
        user="root",  # Replace with your MySQL username
        password=password,
        database="sports_complex"
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

    cursor.execute(
        "SELECT Equipment_ID, Sport, Name FROM sports_complex.Equipment")

    equipment = cursor.fetchall()

    cursor.close()
    conn.close()

    return jsonify(equipment)


@app.route('/checkout_equipment', methods=['POST'])
def checkout_equipment():
    """API endpoint for checking out equipment"""
    data = request.json

    card_id = data['cardID']
    equipment_id = data['equipmentID']

    conn = get_db_connection()

    cursor = conn.cursor()

    # Update equipment table with checkout details
    cursor.execute("""
        UPDATE equipment
        SET checked_out_user_id = (SELECT user_id FROM users WHERE card = %s),
            checkout_time = NOW(),
            due_when = NOW() + INTERVAL 1 DAY
        WHERE equipment_ID = %s AND checked_out_user_id IS NULL;
        """, (card_id, equipment_id))

    if cursor.rowcount == 0:
        message = "Equipment already checked out or invalid."
        status = "error"

    else:
        conn.commit()
        message = "Equipment checked out successfully."
        status = "success"

        # Log activity to CSV file
        with open('activity_log.csv', mode='a', encoding='utf-8') as file:
            file.write(
                f"Checkout,Card ID: {card_id},Equipment ID: {equipment_id}\n")

    cursor.close()

    conn.close()

    return jsonify({"message": message, "status": status})


if __name__ == '__main__':
    app.run(debug=True)
