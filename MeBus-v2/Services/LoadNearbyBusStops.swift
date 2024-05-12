import Foundation
import CoreLocation

class BusStopService {
    
    func loadNearbyBusStops(using locationService: LocationService, completion: @escaping (Result<[(description: String, code: String, roadname: String)], Error>) -> Void) {
        locationService.requestLocation()
        if let userLocation = locationService.currentLocation {
            DispatchQueue.global(qos: .background).async {
                if let closestStops = findClosestBusStops(latitude: userLocation.latitude, longitude: userLocation.longitude) {
                    if let stops = closestStops["stops"] as? [[String: String]] {
                        let result = stops.map { ($0["Description"] ?? "N/A", $0["BusStopCode"] ?? "N/A", $0["RoadName"] ?? "N/A") }
                        completion(.success(result))
                    } else {
                        completion(.failure(NSError(domain: "ParseError", code: 1002, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "DataError", code: 1001, userInfo: nil)))
                }
            }
        } else {
            completion(.failure(NSError(domain: "LocationError", code: 1000, userInfo: nil)))
        }
    }
}
