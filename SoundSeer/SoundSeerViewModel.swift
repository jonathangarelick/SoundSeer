import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI


@Observable class SoundSeerViewModel {
    // This is necessary to fix compiler optimization
    let notificationService = NotificationService.shared
    let playerService = PlayerService.shared

    var currentPlayer: Player?
    var cancellable1: AnyCancellable?
    var cancellable2: AnyCancellable?

    var hasNoMusicPlayer: Bool {
        PlayerService.shared == nil
    }

    var isOutOfSpace: Bool {
        currentPlayer?.playbackState == .playing && prefixLength <= 0
    }

    var isPlaying: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.playbackState == .playing
    }

    var prefixLength = 100

    init() {
        cancellable1 = PlayerService.shared?.currentPlayerSubject
            .assign(to: \.currentPlayer, on: self)

        cancellable2 = ResizeService.shared.currentLengthSubject
            .assign(to: \.prefixLength, on: self)
    }

    deinit {
//        timer?.invalidate()
    }

    var canNextTrack: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.playbackState != .stopped
    }

    func nextTrack() {
        currentPlayer?.nextTrack()
    }

    var canRevealSong: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canRevealSong()
    }

    func revealSong() {
        currentPlayer?.revealSong()
    }

    var canRevealArtist: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canRevealArtist()
    }

    func revealArtist() {
        currentPlayer?.revealArtist()
    }

    var canRevealAlbum: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canRevealAlbum()
    }

    func revealAlbum() {
        currentPlayer?.revealAlbum()
    }

    var canCopySongExternalURL: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canCopySongExternalURL()
    }

    func copySongExternalURL() {
        currentPlayer?.copySongExternalURL()
    }

    var songShort: String {
        guard let song = currentPlayer?.song, !song.isEmpty else { return "Song unknown" }
        return prefixLength > 0
           ? song.truncate(length: Int(Double(prefixLength) * 1.5))
           : song.truncate(length: 60)
    }

    var artistShort: String {
        guard let artist = currentPlayer?.artist, !artist.isEmpty else { return "Artist unknown" }
        return prefixLength > 0
           ? artist.truncate(length: Int(Double(prefixLength) * 1.5))
           : artist.truncate(length: 60)
    }

    var albumShort: String {
        guard let album = currentPlayer?.album, !album.isEmpty else { return "Album unknown" }

        return prefixLength > 0
           ? album.truncate(length: Int(Double(prefixLength) * 1.5))
           : album.truncate(length: 60)
    }

    // MARK: - Dynamic resizing
//    static let maxPrefixLength = 100
//    var isAppVisibleInMenuBar: Bool = false // This will trigger dynamic resizing on startup, just to be safe
//    var prefixLength = maxPrefixLength
//
//    private var timer: Timer?

    var nowPlaying: String {
        get {
            guard let song = currentPlayer?.song, let artist = currentPlayer?.artist else { return "" }

            if song.isEmpty || artist.isEmpty {
                return ""
            } else {
                return "\(song/*.prefixBefore("(")*/) · \(artist)".truncate(length: prefixLength)
            }
        }
    }


    func resetWidth() {
//        prefixLength = Self.maxPrefixLength
    }

    /*
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

        if currentPlayer?.playbackState == .playing, !isVisible, !Self.isAppInMenuBar("SoundSeer") {
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
     */
}
