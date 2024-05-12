import SwiftUI

struct FavoritesView: View {
    @State private var savedBusStops: [String: SavedBusStop] = [:]
    @State private var distances: [String: String] = [:]
    @StateObject private var locationService = LocationService()
    
    var body: some View {
        NavigationView {
            VStack {
                if savedBusStops.isEmpty {
                    Text("No Saved Bus Stops")
                        .italic()
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(Array(savedBusStops.values), id: \.code) { stop in
                            NavigationLink(destination: BusStopDetailView(busStopCode: stop.code, busStopName: stop.description)) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(stop.description)
                                            .font(.headline)
                                            .bold()
                                        Text(stop.roadname)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(distances[stop.code] ?? "Loading...")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 10)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button(action: {
                                    toggleFavorite(stop)
                                }) {
                                    Image(systemName: "heart.slash.fill")
                                }
                                .tint(.red)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                loadSavedBusStops()
                updateDistances()
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
        if var savedStop = savedBusStops[stop.code] {
            savedStop.isFavorited.toggle()
            if savedStop.isFavorited {
                savedBusStops[stop.code] = savedStop
            } else {
                savedBusStops[stop.code] = nil
            }
        } else {
            let newStop = SavedBusStop(code: stop.code, description: stop.description, roadname: stop.roadname, isFavorited: true)
            savedBusStops[stop.code] = newStop
        }
        saveBusStops()
    }
    
    private func updateDistances() {
        for stop in savedBusStops.values {
            findDistance(code: stop.code) { distance in
                DispatchQueue.main.async {
                    self.distances[stop.code] = distance
                }
            }
        }
    }
}

struct FavoriteBusStopsView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
