import Foundation

struct PlayerStateNotification {
    let player: Player
    let playbackState: PlaybackState
    let songName: String?
    let songId: String?
    let artistName: String?
    let albumName: String?
    let albumId: String?

    init?(_ player: Player, _ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        self.player = player
        self.playbackState = PlaybackState(state: playbackStateString)
        self.songName = notification.userInfo?["Name"] as? String

        switch player {
        case .music:
            if let storeURL = notification.userInfo?["Store URL"] as? String,
               let components = URLComponents(string: storeURL),
               let queryItems = components.queryItems {
                songId = queryItems.first(where: { $0.name == "i" })?.value
                albumId = queryItems.first(where: { $0.name == "p" })?.value
            } else {
                songId = nil
                albumId = nil
            }
        case .spotify:
            songId = (notification.userInfo?["Track ID"] as? String)?.components(separatedBy: ":").last
            albumId = nil
        }

        self.artistName = notification.userInfo?["Artist"] as? String
        self.albumName = notification.userInfo?["Album"] as? String
    }
}
