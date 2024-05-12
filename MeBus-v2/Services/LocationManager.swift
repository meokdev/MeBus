import Foundation
import CoreLocation

struct BusStop: Decodable {
    let BusStopCode: String
    let RoadName: String
    let Description: String
    let Latitude: Double
    let Longitude: Double
}

// Define a container to map the owning structure which includes "value" as [BusStop]
struct BusStopsContainer: Decodable {
    let value: [BusStop]
}

func loadJSONDataFromFile() -> Data? {
    guard let filePath = Bundle.main.path(forResource: "BusStopData", ofType: "json") else {
        return nil
    }
    return try? Data(contentsOf: URL(fileURLWithPath: filePath))
}

func parseBusStops(from jsonData: Data) -> [BusStop] {
    let decoder = JSONDecoder()
    
    // Attempt to decode the data using the container struct
    if let busStopsContainer = try? decoder.decode(BusStopsContainer.self, from: jsonData) {
        return busStopsContainer.value
    }
    return []
}

func findClosestBusStops(latitude: Double, longitude: Double) -> [String: Any]? {
    guard let jsonData = loadJSONDataFromFile() else {
        print("Failed to load JSON data")
        print("finding closest bus stop")
        return nil
    }

    let busStops = parseBusStops(from: jsonData)

    let userLocation = CLLocation(latitude: latitude, longitude: longitude)
    let closestTenBusStops = busStops.sorted { first, second in
        let location1 = CLLocation(latitude: first.Latitude, longitude: first.Longitude)
        let location2 = CLLocation(latitude: second.Latitude, longitude: second.Longitude)
        return location1.distance(from: userLocation) < location2.distance(from: userLocation)
    }.prefix(20)

    return ["stops": closestTenBusStops.map { ["Description": $0.Description, "BusStopCode": $0.BusStopCode, "RoadName":$0.RoadName] } ]
}
