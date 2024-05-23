import AppKit

protocol Player {
    var bundleIdentifier: String { get }
    var canCopySongExternalURL: Bool { get }
    var canRevealSong: Bool { get }
    var playerState: PlayerState? { get }

    func copySongExternalURL()
    func nextTrack()
    func revealAlbum()
    func revealArtist()
    func revealSong()
}

extension Player {
    var album: String? {
        playerState?.album
    }

    var artist: String? {
        playerState?.artist
    }

    var canNextTrack: Bool {
        playbackState != .stopped
    }

    var canRevealAlbum: Bool {
        playerState?.songID != nil
    }

    var canRevealArtist: Bool {
        playerState?.songID != nil
    }

    var playbackState: PlaybackState {
        playerState?.playbackState ?? .stopped
    }

    var song: String? {
        playerState?.song
    }

    func isRunning() -> Bool {
        return NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == bundleIdentifier }.count > 0
    }
}
