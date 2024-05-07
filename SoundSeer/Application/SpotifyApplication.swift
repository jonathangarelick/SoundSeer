import AppKit

class SpotifyApplication: Application {
    static let bundleID = "com.spotify.client"
    static let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    private static let instance = SpotifyApplication()

    static var shared: Application {
        instance
    }

    let app = SpotifyBridge.spotifyApplication()

    var songId: String? {
        app?.currentTrack.spotifyUrl.components(separatedBy: ":").last
    }

    private init() {}

    var playerState: PlayerState {
        PlayerState(app?.playerState)
    }

    func copySongURL() {
        guard let songId = songId else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://open.spotify.com/track/\(songId)", forType: .string)
    }

    func nextTrack() {
        app?.nextTrack()
    }

    func revealSong() {
        if let urlString = app?.currentTrack.spotifyUrl, let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }

    func revealArtist() {
        guard let songId = songId else { return }

        SpotifyAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func revealAlbum() {
        guard let songId = songId else { return }

        SpotifyAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
}
