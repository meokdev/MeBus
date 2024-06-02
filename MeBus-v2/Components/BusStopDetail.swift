import SwiftUI

struct BusStopDetailView: View {
    var busStopCode: String
    var busStopName: String
    @State private var buses: [Bus] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                    Button("Try Again") {
                        fetchBusArrivalData()
                    }
                } else {
                    if buses.isEmpty {
                        Text("No Buses Currently Operating")
                            .italic()
                            .foregroundColor(.gray)
                    } else {
                        List(buses) { bus in
                            VStack(alignment: .leading) {
                                GeometryReader { geometry in
                                    HStack {
                                        Text(bus.serviceNo)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3.5)
                                        VStack {
                                            Text("Estimated:")
                                                .font(.footnote)
                                            Text(" \(bus.nextBus)")
                                                .fontWeight(.bold)
                                                .foregroundColor(bus.nextBus == "Arriving" ? .green : nil)
                                                .frame(width: (geometry.size.width - (geometry.size.width / 4)) * 1/2)
                                        }
                                        VStack {
                                            Text("Next Bus:")
                                                .font(.footnote)
                                            Text("\(bus.nextBus2)")
                                                .foregroundColor(.gray)
                                        }
                                        .frame(width: (geometry.size.width - (geometry.size.width / 4)) * 1/2)
                                    }
                                }
                            }
                            .padding()
                        }
                        .refreshable {
                            fetchBusArrivalData()
                        }
                    }
                }
            }
            .navigationTitle(busStopName).navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: {
                    fetchBusArrivalData()
                }) {
                    Image(systemName: "arrow.clockwise")
                }
            )
            .onAppear {
                fetchBusArrivalData()
            }
        }
    
    private func fetchBusArrivalData() {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://YOUR API HERE" //put address to api here, must be https
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    errorMessage = "No data received"
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let busArrivalResponse = try decoder.decode(BusArrivalResponse.self, from: data)
                    buses = busArrivalResponse.services.map { service in
                        Bus(
                            serviceNo: service.serviceNo,
                            nextBus: formatEstimatedArrival(service.nextBus?.estimatedArrival),
                            nextBus2: formatEstimatedArrival(service.nextBus2?.estimatedArrival)
                        )
                    }
                } catch {
                    errorMessage = "Error decoding data: \(error.localizedDescription)"
                }
            }
        }
        
        task.resume()
    }
    
    private func formatEstimatedArrival(_ estimatedArrival: String?) -> String {
        guard let estimatedArrival = estimatedArrival,
              let date = ISO8601DateFormatter().date(from: estimatedArrival) else {
            return "null"
        }
        
        let timeInterval = date.timeIntervalSinceNow
        let minutes = Int(timeInterval / 60)
        
        if minutes < 1 {
            return "Arriving"
        } else {
            return "\(minutes) min"
        }
    }
}

struct BusArrivalResponse: Codable {
    let services: [Service]
    
    enum CodingKeys: String, CodingKey {
        case services = "Services"
    }
}

struct Service: Codable {
    let serviceNo: String
    let nextBus: NextBus?
    let nextBus2: NextBus?
    
    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case nextBus = "NextBus"
        case nextBus2 = "NextBus2"
    }
}

struct NextBus: Codable {
    let estimatedArrival: String
    
    enum CodingKeys: String, CodingKey {
        case estimatedArrival = "EstimatedArrival"
    }
}

struct Bus: Identifiable {
    let id = UUID()
    let serviceNo: String
    let nextBus: String
    let nextBus2: String
}

struct NearbyListView_Previews1: PreviewProvider {
    static var previews: some View {
        NearbyListView()
    }
}
