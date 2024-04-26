import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI

class SpotifyViewModel: ObservableObject {
    static let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: SpotifyViewModel.self))

    @Published private(set) var playerState: SpotifyPlaybackState = .stopped

    @Published private(set) var currentSong: String = ""
    @Published private(set) var currentSongId: String = ""
    @Published private(set) var currentArtist: String = ""
    @Published private(set) var currentAlbum: String = ""

    private let spotifyModel: SpotifyModel = SpotifyModel()

    private var cancellables = Set<AnyCancellable>()

    init() {
        $isAppVisibleInMenuBar
            .sink { [weak self] in
                self?.handleVisibilityChange($0)
            }
            .store(in: &cancellables)

        // FIXED BUG (#26):
        // If the user manually clicks play on a song (while currently playing), Spotify will
        // send a stopped and playing event in rapid succession. This prevents the UI from flickering
        spotifyModel.$playerState
            .map { playerState -> AnyPublisher<SpotifyPlaybackState, Never> in
                if playerState == .stopped {
                    return Just(playerState)
                        .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                } else {
                    return Just(playerState).eraseToAnyPublisher()
                }
            }
            .switchToLatest()
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

    deinit { timer?.invalidate() }

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

    // MARK: - Dynamic resizing
    @Published var isAppVisibleInMenuBar: Bool = false // This will trigger dynamic resizing on startup, just to be safe
    @Published var prefixLength = 100

    private var timer: Timer?

    var nowPlaying: String {
        get {
            if currentSong.isEmpty || currentArtist.isEmpty {
                return ""
            } else {
                return "\(currentSong.prefixBefore("(")) · \(currentArtist.prefixBefore(","))".truncate(length: prefixLength)
            }
        }
    }

    // https://stackoverflow.com/a/77304045
    private static func isAppInMenuBar(_ appName: String) -> Bool {
        let processNamesWithStatusItems = Set(
            (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary])
                .filter { $0[kCGWindowLayer] as! Int == 25 }
                .map { $0[kCGWindowOwnerName] as! String }
        )

        return processNamesWithStatusItems.contains(appName)
    }

    private func handleVisibilityChange(_ isVisible: Bool) {
        timer?.invalidate()

        if !isVisible && !Self.isAppInMenuBar("SoundSeer") {
            doDynamicResizing()
        }
    }

    private func doDynamicResizing() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard self.prefixLength > 0 else {
                Self.logger.debug("Prefix length is not positive, dynamic resizing stopped")
                timer.invalidate()
                return
            }

            Self.logger.debug("Current prefix length is \(self.prefixLength), decreasing by 5")
            self.prefixLength -= 5
        }
    }
}
