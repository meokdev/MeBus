import SwiftUI
import CoreLocation

struct SavedBusStop: Codable {
    let code: String
    let description: String
    let roadname: String
    var isFavorited: Bool
}

struct NearbyListView: View {
    @State private var busStops: [(description: String, code: String, roadname: String, distance: String)] = []
    @State private var isLoading = false
    @State private var loadingFailed = false
    @StateObject private var locationService = LocationService()
    private var busStopService = BusStopService()
    @State private var timer: Timer?
    @State private var savedBusStops: [String: SavedBusStop] = [:]

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                } else if loadingFailed {
                    VStack {
                        Text("Failed to load bus stops.")
                        Button("Reload") {
                            loadNearbyBusStops()
                        }.onAppear{
                            loadNearbyBusStops()
                        }
                    }
                } else {
                    List {
                        ForEach(busStops, id: \.code) { stop in
                            NavigationLink(destination: BusStopDetailView(busStopCode: stop.code, busStopName: stop.description)) {
                                HStack {
                                    if savedBusStops[stop.code]?.isFavorited == true {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.red)
                                    } else {
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.clear)
                                    }
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(stop.description)
                                            .font(.headline)
                                            .bold()
                                        Text(stop.roadname)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(stop.distance)
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 10)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button(action: {
                                        toggleFavorite(stop)
                                    }) {
                                        Image(systemName: savedBusStops[stop.code]?.isFavorited == true ? "heart.slash.fill" : "heart.fill")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    }
                    .refreshable {
                        loadCompleteData()
                    }
                }
            }
            .navigationTitle("Nearby")
            .navigationBarItems(trailing:
                Button(action: {
                    loadCompleteData()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            )
            .onAppear {
                loadCompleteData()
            }
        }
    }

    private func loadCompleteData() {
        loadSavedBusStops()
        loadNearbyBusStops()
    }

    func loadNearbyBusStops() {
        isLoading = true
        loadingFailed = false
        busStops = []
        startTimeoutTimer()

        busStopService.loadNearbyBusStops(using: locationService) { result in
            DispatchQueue.main.async {
                self.timer?.invalidate()
                switch result {
                case .success(let stops):
                    self.busStops = stops.map { ($0.description, $0.code, $0.roadname, "Loading...") }
                    self.isLoading = false
                    self.updateDistances()
                case .failure:
                    self.loadingFailed = true
                    self.isLoading = false
                }
            }
        }
    }

    private func startTimeoutTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            if isLoading {
                isLoading = false
                loadingFailed = true
            }
        }
    }

    private func updateDistances() {
        for index in busStops.indices {
            findDistance(code: busStops[index].code) { distance in
                DispatchQueue.main.async {
                    self.busStops[index].distance = distance
                }
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

    private func toggleFavorite(_ stop: (description: String, code: String, roadname: String, distance: String)) {
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

}

struct NearbyListView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyListView()
    }
}
