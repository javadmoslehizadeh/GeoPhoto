
import SwiftUI
import MapKit

struct ContentView: View {

    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Map(initialPosition: .automatic) {
            }
            .mapStyle(.hybrid)
            .ignoresSafeArea()

            VStack {
                header

                Spacer()

                bottomPanel
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("GeoPhoto")
                    .font(.largeTitle.bold())

                Text("Your memories, on the map")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "globe.americas.fill")
                .font(.title)
                .foregroundStyle(.white)
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var bottomPanel: some View {
        VStack(spacing: 16) {
            HStack {
                statItem(title: "Photos", value: "0")
                Spacer()
                statItem(title: "Places", value: "0")
                Spacer()
                statItem(title: "Trips", value: "0")
            }

            Divider()

            HStack {
                tabButton(title: "Map", icon: "map", index: 0)
                Spacer()
                tabButton(title: "Trips", icon: "point.topleft.down.to.point.bottomright.curvepath", index: 1)
                Spacer()
                tabButton(title: "Gallery", icon: "photo.on.rectangle", index: 2)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func statItem(title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.title2.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func tabButton(
        title: String,
        icon: String,
        index: Int
    ) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(
                selectedTab == index ? .blue : .primary
            )
        }
    }
}
