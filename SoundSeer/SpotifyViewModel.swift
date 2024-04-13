import Foundation
import Combine

class SpotifyViewModel: ObservableObject {
    @Published var currentSong: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    private var spotifyModel: SpotifyModel
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.spotifyModel = SpotifyModel()
        startTimer()
        observeSpotifyModel()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] _ in
            self?.spotifyModel.getCurrentSong()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func observeSpotifyModel() {
        spotifyModel.$currentSong
            .assign(to: \.currentSong, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentArtist
            .assign(to: \.currentArtist, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentAlbum
            .assign(to: \.currentAlbum, on: self)
            .store(in: &cancellables)
    }

    deinit {
        stopTimer()
    }
}
