import AppKit
import Combine
import ScriptingBridge

class SpotifyPlayer: Player {
    static let shared: SpotifyPlayer? = SpotifyPlayer()

    let bundleIdentifier: String = "com.spotify.client"

    var canCopySongExternalURL: Bool {
        guard playbackState != .stopped, let songId = playerState?.songID else { return false }
        return !songId.isEmpty
    }

    var canRevealSong: Bool {
        guard playbackState != .stopped, let uriString = sbReference.currentTrack.spotifyUrl else { return false }
        return !uriString.isEmpty
    }

    var playerState: PlayerState? {
        subject.value
    }

    let sbReference: SBSpotifyApplication
    let subject = CurrentValueSubject<PlayerState?, Never>(nil)

    init?() {
        guard let applicationReference = SBApplicationManager.spotifyApp() else { return nil }
        self.sbReference = applicationReference

        if isRunning() {
            subject.send(PlayerState(applicationReference))
        }

        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { [weak self] in
                self?.subject.send(PlayerState($0))
            }
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func copySongExternalURL() {
        guard let songId = playerState?.songID else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://open.spotify.com/track/\(songId)", forType: .string)
    }

    func nextTrack() {
        sbReference.nextTrack()
    }

    func revealAlbum() {
        guard let songId = playerState?.songID else { return }
        SpotifyAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func revealArtist() {
        guard let songId = playerState?.songID else { return }
        SpotifyAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func revealSong() {
        if let uriString = sbReference.currentTrack?.spotifyUrl, let uri = URL(string: uriString) {
            NSWorkspace.shared.open(uri)
        }
    }
}
