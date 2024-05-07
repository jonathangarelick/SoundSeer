import AppKit

class MusicApplication: Application {
    static let app = AppleMusicBridge.appleMusicApplication()
    static var songId: String?
    static var albumId: String?

    private static let instance = MusicApplication()

    static var shared: Application {
        instance
    }

     static func copySongURL() {
        guard let songId = songId, let albumId = albumId else { return }

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://music.apple.com/album/\(albumId)?i=\(songId)", forType: .string)
    }

    static func nextTrack() {
        app?.nextTrack()
    }

    static func revealSong() {
        app?.currentTrack.reveal()
    }

    static func revealArtist() {
        guard let songId = songId else { return }

        MusicAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }

    static func revealAlbum() {
        guard let songId = songId else { return }

        MusicAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
}
