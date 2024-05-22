import AppKit
import Combine
import Foundation
import ScriptingBridge

class AppleMusicPlayer: Player {
    static let shared: AppleMusicPlayer? = AppleMusicPlayer()

    let bundleIdentifier: String = "com.apple.Music"
    let applicationReference: SBMusicApplication

    var lastUpdate: Date {
        Date(timeIntervalSince1970: 0)
    }

    let playerStateSubject = CurrentValueSubject<PlayerState?, Never>(nil)
    var playerState: PlayerState? {
        get {
            playerStateSubject.value
        }
        set {
            playerStateSubject.send(newValue)
        }
    }
    var playbackState: PlaybackState {
        playerState?.playbackState ?? .stopped
    }

    var song: String? {
        playerState?.songName
    }

    var artist: String? {
        playerState?.artistName
    }

    var album: String? {
        playerState?.albumName
    }

    var cancellables = Set<AnyCancellable>()

    init?() {
        guard let applicationReference = SBApplicationManager.musicApp() else { return nil }
        self.applicationReference = applicationReference

        if isRunning() {
            playerState = PlayerState(.appleMusic, applicationReference)
        }

        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.apple.Music.playerInfo"), object: nil, queue: nil) { [weak self] in
                self?.playerStateSubject.send(PlayerState(.appleMusic, $0))
            }
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func canNextTrack() -> Bool {
        return playbackState != .stopped
    }

    func nextTrack() {
        applicationReference.nextTrack()
    }

    func canRevealSong() -> Bool {
        return playbackState != .stopped
    }

    func revealSong() {
        applicationReference.currentTrack?.reveal()
        applicationReference.activate() // Reveal does not bring the app to the foreground
    }

    func canRevealArtist() -> Bool {
        guard playbackState != .stopped, let songId = playerState?.songId else { return false }
        return !songId.isEmpty
    }

    func revealArtist() {
        guard let songId = playerState?.songId else { return }
        MusicAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func canRevealAlbum() -> Bool {
        guard playbackState != .stopped, let songId = playerState?.songId else { return false }
        return !songId.isEmpty
    }

    func revealAlbum() {
        guard let songId = playerState?.songId else { return }
        MusicAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func canCopySongExternalURL() -> Bool {
        guard playbackState != .stopped, let songId = playerState?.songId, let albumId = playerState?.albumId else { return false }
        return !songId.isEmpty && !albumId.isEmpty
    }

    func copySongExternalURL() {
        guard let songId = playerState?.songId, let albumId = playerState?.albumId else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://music.apple.com/album/\(albumId)?i=\(songId)", forType: .string)
    }
}
