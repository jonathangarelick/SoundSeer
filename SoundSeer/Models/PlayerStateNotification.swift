import Foundation

struct PlayerStateNotification {
    let application: Application
    let playerState: PlayerState
    let songName: String?
    let songId: String?
    let artistName: String?
    let albumName: String?
    let albumId: String?

    init?(_ player: Application, _ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        self.application = player
        self.playerState = PlayerState(state: playbackStateString)
        self.songName = notification.userInfo?["Name"] as? String

        switch player {
        case is MusicApplication:
            if let storeURL = notification.userInfo?["Store URL"] as? String,
               let components = URLComponents(string: storeURL),
               let queryItems = components.queryItems {
                songId = queryItems.first(where: { $0.name == "i" })?.value
                albumId = queryItems.first(where: { $0.name == "p" })?.value
            } else {
                songId = nil
                albumId = nil
            }
        case is SpotifyApplication:
            songId = (notification.userInfo?["Track ID"] as? String)?.components(separatedBy: ":").last
            albumId = nil
        default:
            songId = nil
            albumId = nil
        }

        self.artistName = notification.userInfo?["Artist"] as? String
        self.albumName = notification.userInfo?["Album"] as? String
    }
}
