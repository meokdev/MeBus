from flask import Flask, jsonify, request
from flask_cors import CORS
import requests

# Initialize the Flask application
app = Flask(__name__)
CORS(app)  # Enable CORS

def get_bus_arrival_data(bus_stop_code):
    """ Function to fetch bus arrival data from the specified API using a bus stop code """
    url = f"http://datamall2.mytransport.sg/ltaodataservice/BusArrivalv2?BusStopCode={bus_stop_code}"
    headers = {
        'AccountKey': 'Cd1meRZJTR6xuMO6B8NNjw== '
    }
    response = requests.get(url, headers=headers)
    return response.json()  # Return the JSON response directly

@app.route('/bus-arrival/<code>')
def bus_arrival(code):
    """ Route to return bus arrival data based on a bus stop code """
    if not code:
        return jsonify({"error": "Missing bus stop code"}), 400
    data = get_bus_arrival_data(code)
    return jsonify(data)  # Use jsonify to ensure response is application/json

if __name__ == '__main__':
    app.run(debug=True, port=6001)  # Run the application in debug mode
