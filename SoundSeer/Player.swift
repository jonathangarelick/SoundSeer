import AppKit
import ScriptingBridge

enum PlayerType {
    case appleMusic, spotify
}

protocol Player {
    var bundleIdentifier: String { get }
    var lastUpdate: Date { get }

    var playbackState: PlaybackState { get }

    var song: String? { get }
    var artist: String? { get }
    var album: String? { get }

    func canNextTrack() -> Bool
    func nextTrack()
    func canRevealSong() -> Bool
    func revealSong()
    func canRevealArtist() -> Bool
    func revealArtist()
    func canRevealAlbum() -> Bool
    func revealAlbum()
    func canCopySongExternalURL() -> Bool
    func copySongExternalURL()
}

extension Player {
    func isInstalled() -> Bool {
        return NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier) != nil
    }

    func isRunning() -> Bool {
        return NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == bundleIdentifier }.count > 0
    }
}
