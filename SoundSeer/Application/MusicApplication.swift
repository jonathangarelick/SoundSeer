import AppKit

class MusicApplication: Application {
    private static let instance = MusicApplication()

    let app = AppleMusicBridge.appleMusicApplication()
    var songId: String?
    var albumId: String?

    private init() {}

    static var shared: Application {
        instance
    }

     func copySongURL() {
        guard let songId = songId, let albumId = albumId else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://music.apple.com/album/\(albumId)?i=\(songId)", forType: .string)
    }

    func nextTrack() {
        app?.nextTrack()
    }

    func revealSong() {
        app?.currentTrack.reveal()
    }

    func revealArtist() {
        guard let songId = songId else { return }

        MusicAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    func revealAlbum() {
        guard let songId = songId else { return }

        MusicAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
}
