import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI

enum ViewModelState {
    case ok, noMusicPlayer, outOfSpace
}

class SoundSeerViewModel: ObservableObject {
    let model: SoundSeerModel? = SoundSeerModel()

    @Published var playerState: PlayerState?

    var player: Player? {
        playerState?.player
    }

    var playbackState: PlaybackState? {
        playerState?.playbackState
    }

    var currentSong: String {
        playerState?.songName ?? ""
    }

    var currentSongId: String {
        playerState?.songId ?? ""
    }

    var currentArtist: String {
        playerState?.artistName ?? ""
    }

    var currentAlbum: String {
        playerState?.albumName ?? ""
    }

    var currentAlbumId: String {
        playerState?.albumId ?? ""
    }

    var isPlayerStopped: Bool {
        guard let playbackState = playbackState else { return true }
        return playbackState == .stopped
    }

    var isPlaying: Bool {
        playbackState == .playing
    }

    var isValid: Bool {
        model != nil
    }

    var hasNoMusicPlayer: Bool {
        model == nil
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        $isAppVisibleInMenuBar
            .sink { [weak self] in
                self?.handleVisibilityChange($0)
            }
            .store(in: &cancellables)

        model?.$playerState
            .assign(to: \.playerState, on: self)
            .store(in: &cancellables)
    }

    deinit { timer?.invalidate() }

    func nextTrack() {
        guard let player = player else { return }
        switch player {
        case .music:
            MusicApplication.app?.nextTrack()
        case .spotify:
            SpotifyApplication.app?.nextTrack()
        }
    }

    var songShort: String {
        guard !currentSong.isEmpty else { return "Song unknown" }

        return prefixLength > 0
           ? currentSong.truncate(length: Int(Double(prefixLength) * 1.5))
           : currentSong.truncate(length: 60)
    }

    var canRevealSong: Bool {
        player != nil
    }

    func revealSong() {
        guard let player = player else { return }
        switch player {
        case .music:
            MusicApplication.app?.currentTrack?.reveal()
        case .spotify:
            if let uriString = SpotifyApplication.app?.currentTrack?.spotifyUrl, let uri = URL(string: uriString) {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    var artistShort: String {
        guard !currentArtist.isEmpty else { return "Artist unknown" }

        return prefixLength > 0
           ? currentArtist.truncate(length: Int(Double(prefixLength) * 1.5))
           : currentArtist.truncate(length: 60)
    }

    var canRevealArtist: Bool {
        !currentSongId.isEmpty
    }

    func revealArtist() {
        guard let player = player, !currentSongId.isEmpty else { return }
        switch player {
        case .music:
            MusicAPI.getURI(songId: currentSongId, for: .artist) { uri in
                if let uri = uri {
                    NSWorkspace.shared.open(uri)
                }
            }
        case .spotify:
            SpotifyAPI.getURI(songId: currentSongId, for: .artist) { uri in
                if let uri = uri {
                    NSWorkspace.shared.open(uri)
                }
            }
        }
    }

    var albumShort: String {
        guard !currentAlbum.isEmpty else { return "Album unknown" }
        
        return prefixLength > 0
           ? currentAlbum.truncate(length: Int(Double(prefixLength) * 1.5))
           : currentAlbum.truncate(length: 60)
    }

    var canRevealAlbum: Bool {
        !currentSongId.isEmpty
    }

    func revealAlbum() {
        guard let player = player, !currentSongId.isEmpty else { return }
        switch player {
        case .music:
            MusicAPI.getURI(songId: currentSongId, for: .album) { uri in
                if let uri = uri {
                    NSWorkspace.shared.open(uri)
                }
            }
        case .spotify:
            SpotifyAPI.getURI(songId: currentSongId, for: .album) { uri in
                if let uri = uri {
                    NSWorkspace.shared.open(uri)
                }
            }
        }
    }

    func copySongExternalURL() {
        guard let player = player, !currentSongId.isEmpty else { return }
        switch player {
        case .music:
            guard !currentAlbumId.isEmpty else { return }
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString("https://music.apple.com/album/\(currentAlbumId)?i=\(currentSongId)", forType: .string)
        case .spotify:
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([.string], owner: nil)
            pasteboard.setString("https://open.spotify.com/track/\(currentSongId)", forType: .string)
        }
    }

    // MARK: - Dynamic resizing
    @Published var isAppVisibleInMenuBar: Bool = false // This will trigger dynamic resizing on startup, just to be safe
    @Published var prefixLength = 45

    private var timer: Timer?

    var nowPlaying: String {
        get {
            if currentSong.isEmpty || currentArtist.isEmpty {
                return ""
            } else {
                return "\(currentSong.prefixBefore("(")) · \(currentArtist)".truncate(length: prefixLength)
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

        if playerState?.playbackState == .playing, !isVisible, !Self.isAppInMenuBar("SoundSeer") {
            doDynamicResizing()
        }
    }

    private func doDynamicResizing() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard self.prefixLength > 0 else {
                Logger.view.debug("Prefix length is not positive, dynamic resizing stopped")
                timer.invalidate()
                return
            }

            Logger.view.debug("Current prefix length is \(self.prefixLength), decreasing by 5")
            self.prefixLength -= 5
        }
    }
}
