import AppKit
import Combine
import ScriptingBridge

class SpotifyPlayer: Player {
    static let shared: SpotifyPlayer? = SpotifyPlayer()

    let bundleIdentifier: String = "com.spotify.client"
    let applicationReference: SBSpotifyApplication

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
        guard let applicationReference = SBApplicationManager.spotifyApp() else { return nil }
        self.applicationReference = applicationReference

        if isRunning() {
            playerState = PlayerState(.spotify, applicationReference)
        }

        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { [weak self] in
                self?.playerStateSubject.send(PlayerState(.spotify, $0))
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
        guard playbackState != .stopped, let uriString = applicationReference.currentTrack.spotifyUrl else { return false }
        return !uriString.isEmpty
    }

    func revealSong() {
        if let uriString = applicationReference.currentTrack?.spotifyUrl, let uri = URL(string: uriString) {
            NSWorkspace.shared.open(uri)
        }
    }

    func canRevealArtist() -> Bool {
        guard playbackState != .stopped, let songId = playerState?.songId else { return false }
        return !songId.isEmpty
    }

    func revealArtist() {
        guard let songId = playerState?.songId else { return }
        SpotifyAPI.getURI(songId: songId, for: .artist) { uri in
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
        SpotifyAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func canCopySongExternalURL() -> Bool {
        guard playbackState != .stopped, let songId = playerState?.songId else { return false }
        return !songId.isEmpty
    }

    func copySongExternalURL() {
        guard let songId = playerState?.songId else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://open.spotify.com/track/\(songId)", forType: .string)
    }
}
