import SwiftUI

struct BottomNavBar: View {
    @State private var selectedTab = 1
    @ObservedObject private var keyboardResponder = KeyboardResponder()
    
    var body: some View {
        VStack {
            // Content view based on the selected tab
            switch selectedTab {
            case 0:
                FavoritesView()
            case 1:
                NearbyListView()
            case 2:
                Search_BusStopSearchView()
            default:
                EmptyView()
            }
            
            if !keyboardResponder.isVisible {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 24))
                            Text("Favorites")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(selectedTab == 0 ? .blue : .gray)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "bus")
                                .font(.system(size: 24))
                            Text("Nearby")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(selectedTab == 1 ? .blue : .gray)
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                            Text("Search")
                                .font(.caption)
                        }
                    }
                    .foregroundColor(selectedTab == 2 ? .blue : .gray)
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
    }
}

struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
    }
}
