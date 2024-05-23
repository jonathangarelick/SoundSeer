import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI


@Observable class SoundSeerViewModel {
    // Prevent these from being optimized away
    let playerService = CurrentPlayerService.shared
    let resizeService = ResizeService.shared

    var currentPlayer: Player?
    var cancellable1: AnyCancellable?
    var cancellable2: AnyCancellable?

    var hasNoMusicPlayer: Bool {
        CurrentPlayerService.shared.subject.value == nil
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
        cancellable1 = playerService.subject
            .assign(to: \.currentPlayer, on: self)

        cancellable2 = resizeService.subject
            .assign(to: \.prefixLength, on: self)
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
        return currentPlayer.canRevealSong
    }

    func revealSong() {
        currentPlayer?.revealSong()
    }

    var canRevealArtist: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canRevealArtist
    }

    func revealArtist() {
        currentPlayer?.revealArtist()
    }

    var canRevealAlbum: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canRevealAlbum
    }

    func revealAlbum() {
        currentPlayer?.revealAlbum()
    }

    var canCopySongExternalURL: Bool {
        guard let currentPlayer = currentPlayer else { return false }
        return currentPlayer.canCopySongExternalURL
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

    var nowPlaying: String {
        get {
            guard let song = currentPlayer?.song, let artist = currentPlayer?.artist else { return "" }

            if song.isEmpty || artist.isEmpty {
                return ""
            } else {
                return "\(song.prefixBefore("(")) · \(artist)".truncate(length: prefixLength)
            }
        }
    }

    func resetWidth() {
        ResizeService.shared.resetSubject()
    }
}
