import AppKit

class SpotifyApplication: Application {
    static let app = SpotifyBridge.spotifyApplication()

    private static let instance = SpotifyApplication()

    static var shared: Application {
        instance
    }

    private static var songId: String? {
        app?.currentTrack.spotifyUrl.components(separatedBy: ":").last
    }

    static func copySongURL() {
        guard let songId = songId else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://open.spotify.com/track/\(songId)", forType: .string)
    }

    static func nextTrack() {
        app?.nextTrack()
    }

    static func revealSong() {
        if let urlString = app?.currentTrack.spotifyUrl, let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }

    static func revealArtist() {
        guard let songId = songId else { return }

        SpotifyAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    static func revealAlbum() {
        guard let songId = songId else { return }

        SpotifyAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
}
