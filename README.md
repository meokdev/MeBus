# MeBus
#### A fully functional, minimalistic bus app written in Swift.

MeBus is a compact and efficient iOS application tailored for the commuters in Singapore. Utilizing the LTA API, it offers real-time information about nearby bus stops, incoming buses, favorite bus stops, and a comprehensive search for all bus stops.

## Features
- **View Nearby Bus Stops:** Automatically detects and displays bus stops in the vicinity.
- **Incoming Buses:** Shows incoming buses for each bus stop.
- **Favorite Bus Stops:** Allows users to save favorite bus stops for quick access.
- **Search Bus Stops:** Search functionality to view bus timings for any bus stop.

##Requirements
- Xcode
- External server or computer for hosting API
- Internet connection

## Setup Instructions

### iOS App Setup
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/MeBus.git
   cd MeBus
   ```
   
2. **Open in Xcode:**
   - Open `MeBus.xcodeproj` in Xcode.

3. **Configure the App:**
   - **API Configuration:**
     Set the API endpoint in your Swift code to point to the running Flask server's public address.

4. **Build and Run:**
   - Build the project in Xcode and run it on your device or simulator.

### API Setup

1. **Navigate to the API Directory:**
   ```bash
   cd API
   ```

2. **Install Dependencies:**
   Ensure you have `pip` installed. Then, install the required Python packages:
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the Flask Server:**
   Make sure the script is accessible over the public internet. You may use a service like [ngrok](https://ngrok.com/) for this purpose.
   ```bash
   python bus_api.py
   ```

   If you're using ngrok:
   ```bash
   ngrok http 5000
   ```

4. **Configure the Swift App:**
   - Update the API URL in your Swift code to point to the ngrok public address or your server's public IP/domain.

## API Overview
The Flask API powers the app by providing data retrieved from the LTA API. Below are the details of the API script:

- **Location:** `API/bus_api.py`
- **Dependencies:** `Flask`, `requests`
- **Main Functions:**
  - Retrieve bus arrival times
 
*Note: https is required for the API to work in production. You can not use http*


## Images

   <img src="https://github.com/meokdev/MeBus/assets/62682756/6e67bdcb-d2d1-4750-afe8-47f4abbc32f1" width="200">
   <img src="https://github.com/meokdev/MeBus/assets/62682756/460b8ee5-ec88-418f-a48d-e9fc06b86701" width="200">
   <img src="https://github.com/meokdev/MeBus/assets/62682756/2b3ea914-2ab7-4eb9-ae5c-4bd807c94c20" width="200">
   <img src="https://github.com/meokdev/MeBus/assets/62682756/a8f1ec3f-4584-41b3-88ce-7af26c5eb6a7" width="200">
   <img src="https://github.com/meokdev/MeBus/assets/62682756/f54ea11e-ea21-4da6-986f-e6b3800abbc9" width="200">


## Contributing
Contributions are welcome! Please submit a pull request or open an issue for any improvements or bug fixes.

## License
This project is licensed under the MIT License.

## Contact
For any questions or support, please message `.meok` on Discord.

