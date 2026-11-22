
import SwiftUI
import Photos
import CoreLocation

struct GeoPhotoItem: Identifiable {
    let id: String
    let date: Date?
    let coordinate: CLLocationCoordinate2D
    let asset: PHAsset
}

@MainActor
final class PhotoLibraryManager: ObservableObject {

    @Published var photos: [GeoPhotoItem] = []
    @Published var isLoading = false
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined

    func requestAccessAndLoad() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        authorizationStatus = status

        guard status == .authorized || status == .limited else {
            return
        }

        await loadPhotos()
    }

    private func loadPhotos() async {
        isLoading = true
        defer { isLoading = false }

        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]

        let result = PHAsset.fetchAssets(
            with: .image,
            options: options
        )

        var items: [GeoPhotoItem] = []

        result.enumerateObjects { asset, _, _ in
            guard let location = asset.location else {
                return
            }

            let item = GeoPhotoItem(
                id: asset.localIdentifier,
                date: asset.creationDate,
                coordinate: location.coordinate,
                asset: asset
            )

            items.append(item)
        }

        photos = items
    }
}
