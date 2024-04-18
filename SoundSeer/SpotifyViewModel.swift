import Foundation
import AppKit
import Combine

import LaunchAtLogin

class SpotifyViewModel: ObservableObject {
    @Published private(set) var playerState: SpotifyEPlSTyped = .stopped

    @Published private(set) var currentSong: String = ""
    @Published private(set) var currentSongId: String = ""
    @Published private(set) var currentArtist: String = ""
    @Published private(set) var currentAlbum: String = ""

    var nowPlaying: String {
        get {
            if currentSong.isEmpty || currentArtist.isEmpty {
                return ""
            } else {
                return "\(currentSong.prefixBefore("(")) - \(currentArtist.prefixBefore(","))".truncate(length: 30)
            }
        }
    }

    private let spotifyModel: SpotifyModel = SpotifyModel()

    private var cancellables = Set<AnyCancellable>()

    init() {
        spotifyModel.$playerState
            .assign(to: \.playerState, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentSong
            .assign(to: \.currentSong, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentSongId
            .assign(to: \.currentSongId, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentArtist
            .assign(to: \.currentArtist, on: self)
            .store(in: &cancellables)

        spotifyModel.$currentAlbum
            .assign(to: \.currentAlbum, on: self)
            .store(in: &cancellables)
    }

    func nextTrack() {
        spotifyModel.nextTrack()
    }

    func openCurrentSong() {
        SpotifyAPI.getSpotifyURI(from: currentSongId, type: .song) { uri in
            if let uriString = uri, let url = URL(string: uriString) {
                NSWorkspace.shared.open(url)
            }
        }
    }

    func openCurrentArtist() {
        SpotifyAPI.getSpotifyURI(from: currentSongId, type: .artist) { uri in
            if let uriString = uri, let url = URL(string: uriString) {
                NSWorkspace.shared.open(url)
            }
        }
    }

    func openCurrentAlbum() {
        SpotifyAPI.getSpotifyURI(from: currentSongId, type: .album) { uri in
            if let uriString = uri, let url = URL(string: uriString) {
                NSWorkspace.shared.open(url)
            }
        }
    }

    func copySpotifyExternalURL() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://open.spotify.com/track/\(currentSongId)", forType: .string)
    }

    func toggleOpenAtLogin() {
        LaunchAtLogin.isEnabled.toggle()
    }

    func quitSoundSeer() {
        NSApplication.shared.terminate(nil)
    }
}







