import SwiftUI

// BottomNavBar component
struct BottomNavBar: View {
    @State private var selectedTab = 1
    
    var body: some View {
        VStack {
            // Content view based on the selected tab
            switch selectedTab {
            case 0:
                FavoritesView()
            case 1:
                NearbyListView()

            default:
                EmptyView()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    selectedTab = 0
                }) {
                    VStack {
                        Image(systemName: "heart.fill") // changed to filled heart
                            .font(.system(size: 24)) // larger icon
                        Text("Favorites")
                            .font(.caption) // smaller text
                    }
                }
                .foregroundColor(selectedTab == 0 ? .blue : .gray)
                
                Spacer()
                Spacer()
                
                Button(action: {
                    selectedTab = 1
                }) {
                    VStack {
                        Image(systemName: "bus")
                            .font(.system(size: 24)) // larger icon
                        Text("Nearby")
                            .font(.caption) // smaller text
                    }
                }
                .foregroundColor(selectedTab == 1 ? .blue : .gray)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

// Preview provider for SwiftUI previews
struct BottomNavBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBar()
    }
}

