
import Foundation

struct Search_BusStop: Codable, Identifiable {
    let id = UUID()
    let Latitude: Double
    let Longitude: Double
    let Description: String
    let RoadName: String
    let BusStopCode: String
    
    enum CodingKeys: String, CodingKey {
        case Latitude, Longitude, Description, RoadName, BusStopCode
    }
}

func Search_loadBusStops() -> [Search_BusStop] {
    guard let url = Bundle.main.url(forResource: "BusStopData", withExtension: "json") else {
        fatalError("BusStopData.json not found")
    }
    
    do {
        let data = try Data(contentsOf: url)
        let busStops = try JSONDecoder().decode([String: [Search_BusStop]].self, from: data)
        return busStops["value"] ?? []
    } catch {
        fatalError("Error loading bus stops: \(error)")
    }
}

func Search_fuzzySearch(searchText: String, busStops: [Search_BusStop]) -> [Search_BusStop] {
    if searchText.isEmpty {
        return []
    }

    // Perform a simple fuzzy search by checking if the searchText is a substring in either Description or RoadName
    let filteredBusStops = busStops.filter { busStop in
        busStop.Description.localizedCaseInsensitiveContains(searchText) || busStop.RoadName.localizedCaseInsensitiveContains(searchText)
    }
    return Array(filteredBusStops.prefix(6))  // Return the first 5 closest matches
}
