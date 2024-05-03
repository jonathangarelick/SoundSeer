import Foundation

struct PlayerStateNotification {
    let player: Player
    let playbackState: PlaybackState
    let songName: String?
    let artistName: String?
    let albumName: String?

    init?(_ player: Player, _ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        self.player = player
        self.playbackState = PlaybackState(state: playbackStateString)
        self.songName = notification.userInfo?["Name"] as? String
        self.artistName = notification.userInfo?["Artist"] as? String
        self.albumName = notification.userInfo?["Album"] as? String
    }
}
