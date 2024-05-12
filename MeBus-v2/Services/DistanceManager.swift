import Foundation
import CoreLocation

struct BusStop1: Codable {
    var BusStopCode: String
    var RoadName: String
    var Description: String
    var Latitude: Double
    var Longitude: Double
}

struct BusStops: Codable {
    var value: [BusStop1]
}

func loadBusStops() -> [BusStop1] {
    guard let url = Bundle.main.url(forResource: "BusStopData", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return []
    }

    let decoder = JSONDecoder()
    if let jsonData = try? decoder.decode(BusStops.self, from: data) {
        return jsonData.value
    }
    return []
}


func findDistance(code: String, completion: @escaping (String) -> Void) {
    let busStops = loadBusStops()
    if let targetStop = busStops.first(where: { $0.BusStopCode == code }) {
        let stopLocation = CLLocation(latitude: targetStop.Latitude, longitude: targetStop.Longitude)
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            if let userLocation = locationManager.location {
                let distanceInMeters = userLocation.distance(from: stopLocation)
                
                if distanceInMeters > 1000 {
                    let distanceInKilometers = distanceInMeters / 1000
                    completion(String(format: "%.1f km", distanceInKilometers))
                } else {
                    completion("\(Int(distanceInMeters)) m")
                }
            } else {
                print("User location is not available.")
                completion("Error")
            }
        } else {
            print("Location services are not enabled.")
            completion("Error")
        }
    } else {
        print("No bus stop with that code.")
        completion("Error")
    }
}

