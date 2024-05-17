import SwiftUI
import CoreLocation

struct Search_BusStopSearchView: View {
    @State private var searchText = ""
    @State private var busStops: [Search_BusStop] = []
    @State private var searchResults: [Search_BusStop] = []
    @State private var savedBusStops: [String: SavedBusStop] = [:]
    @State private var distances: [String: String] = [:] // Dictionary to hold distances

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for bus stops...", text: $searchText)
                    .padding(15) // Increase padding
                    .background(Color(.systemGray6)) // Change background color
                    .cornerRadius(10) // Rounded corners
                    .font(.system(size: 18, weight: .medium, design: .rounded)) // Change font size and style
                    .padding(.horizontal, 20) // Add padding on the sides
                    .onChange(of: searchText) { value in
                        searchResults = Search_fuzzySearch(searchText: value, busStops: busStops)
                        loadDistancesForSearchResults()
                    }

                List(searchResults) { busStop in
                    NavigationLink(destination: BusStopDetailView(busStopCode: busStop.BusStopCode, busStopName: busStop.Description)) {
                        HStack {
                            if savedBusStops[busStop.BusStopCode]?.isFavorited == true {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.red)
                            } else {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.clear)
                            }
                            VStack(alignment: .leading, spacing: 10) {
                                Text(busStop.Description)
                                    .font(.headline)
                                    .bold()
                                Text(busStop.RoadName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            // Display the distance
                            if let distance = distances[busStop.BusStopCode] {
                                Text(distance)
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.vertical, 10)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button(action: {
                                let stop = SavedBusStop(
                                    code: busStop.BusStopCode,
                                    description: busStop.Description,
                                    roadname: busStop.RoadName,
                                    isFavorited: !(savedBusStops[busStop.BusStopCode]?.isFavorited ?? false)
                                )
                                toggleFavorite(stop)
                            }) {
                                Image(systemName: savedBusStops[busStop.BusStopCode]?.isFavorited == true ? "heart.slash.fill" : "heart.fill")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            .navigationBarTitle("Search")
            .onAppear {
                busStops = Search_loadBusStops()
                loadSavedBusStops()
            }
        }
    }

    private func loadSavedBusStops() {
        if let data = UserDefaults.standard.data(forKey: "SavedBusStops"),
           let decoded = try? JSONDecoder().decode([String: SavedBusStop].self, from: data) {
            savedBusStops = decoded
        }
    }

    private func saveBusStops() {
        if let encoded = try? JSONEncoder().encode(savedBusStops) {
            UserDefaults.standard.set(encoded, forKey: "SavedBusStops")
        }
    }

    private func toggleFavorite(_ stop: SavedBusStop) {
        if let existingStop = savedBusStops[stop.code] {
            savedBusStops[stop.code]?.isFavorited.toggle()
            if savedBusStops[stop.code]?.isFavorited == false {
                savedBusStops[stop.code] = nil
            }
        } else {
            savedBusStops[stop.code] = stop
        }
        saveBusStops()
    }
    
    private func loadDistancesForSearchResults() {
        for busStop in searchResults {
            findDistance(code: busStop.BusStopCode) { distance in
                DispatchQueue.main.async {
                    self.distances[busStop.BusStopCode] = distance
                }
            }
        }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        Search_BusStopSearchView()
    }
}
