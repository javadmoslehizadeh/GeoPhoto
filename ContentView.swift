
import SwiftUI
import MapKit
import Photos
import CoreLocation

struct ContentView: View {

    @StateObject private var photoManager = PhotoLibraryManager()
    @State private var selectedPhoto: GeoPhotoItem?

    var body: some View {
        ZStack {
            Map {
                ForEach(photoManager.photos) { photo in
                    Annotation(
                        photo.date?.formatted(date: .abbreviated, time: .omitted) ?? "Photo",
                        coordinate: photo.coordinate
                    ) {
                        Button {
                            selectedPhoto = photo
                        } label: {
                            Image(systemName: "photo.circle.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(.white, .blue)
                                .shadow(radius: 4)
                        }
                    }
                }
            }
            .mapStyle(.hybrid)
            .ignoresSafeArea()

            VStack {
                header

                Spacer()

                bottomPanel
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .task {
            await photoManager.requestAccessAndLoad()
        }
        .sheet(item: $selectedPhoto) { photo in
            PhotoDetailsView(photo: photo)
                .presentationDetents([.medium])
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("GeoPhoto")
                    .font(.largeTitle.bold())

                Text("Your memories, on the map")
                    .font(.caption)
            }

            Spacer()

            Image(systemName: "globe.americas.fill")
                .font(.title)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var bottomPanel: some View {
        HStack {
            statItem(
                title: "Photos",
                value: "\(photoManager.photos.count)"
            )

            Spacer()

            statItem(title: "Places", value: "\(photoManager.photos.count)")

            Spacer()

            statItem(title: "Trips", value: "0")
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
}

struct PhotoDetailsView: View {
    let photo: GeoPhotoItem

    var body: some View {
        VStack(spacing: 16) {
            Text("Photo Location")
                .font(.title.bold())

            Text(photo.date?.formatted(date: .long, time: .shortened) ?? "Unknown date")

            Text("Latitude: \(photo.coordinate.latitude)")
            Text("Longitude: \(photo.coordinate.longitude)")
        }
        .padding()
    }
}
