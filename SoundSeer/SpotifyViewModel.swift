import AppKit
import Combine
import Foundation
import SwiftUI

class SpotifyViewModel: ObservableObject {
    @Published private(set) var playerState: SpotifyEPlSTyped = .stopped

    @Published private(set) var currentSong: String = ""
    @Published private(set) var currentSongId: String = ""
    @Published private(set) var currentArtist: String = ""
    @Published private(set) var currentAlbum: String = ""

    @Published var prefixLength = 100
    @Published var isVisible: Bool = false

    var nowPlaying: String {
        get {
            if currentSong.isEmpty || currentArtist.isEmpty {
                return ""
            } else {
                return "\(currentSong/*.prefixBefore("(")*/) · \(currentArtist/*.prefixBefore(",")*/)".truncate(length: prefixLength)
            }
        }
    }

    private let spotifyModel: SpotifyModel = SpotifyModel()

    private var cancellables = Set<AnyCancellable>()

    init() {
        $isVisible
            .sink { [weak self] in
                self?.handleVisibilityChange($0)
            }
            .store(in: &cancellables)

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
    
    func quitSoundSeer() {
        NSApplication.shared.terminate(nil)
    }

    func handleVisibilityChange(_ isVisible: Bool) {
        if !isVisible && !isInMenuBar() {
            startResizing()
        } else {
            stopResizing()
        }
    }

    private var timer: Timer?


    private func startResizing() {
        timer?.invalidate()

        // Something is very wrong
        guard prefixLength > 0 else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let strongSelf = self else { return }
            guard strongSelf.prefixLength >= 0 else {
                strongSelf.timer?.invalidate()
                return
            }

            strongSelf.prefixLength -= 5
            print("New prefix length:", strongSelf.prefixLength)
        }
    }

    private func stopResizing() {
        timer?.invalidate()
        timer = nil
    }

    func isInMenuBar() -> Bool {
        let processNamesWithStatusItems = Set(
            (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary])
                .filter { $0[kCGWindowLayer] as! Int == 25 }
                .map { $0[kCGWindowOwnerName] as! String }
        )

        return processNamesWithStatusItems.contains("SoundSeer")
    }
}







