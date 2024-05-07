import Foundation

class PlayerState: ObservableObject {
    let player: Player
    let playbackState: PlaybackState
    let songName: String?
    let songId: String?
    let artistName: String?
    let albumName: String?
    let albumId: String?

    init?(_ player: Player, _ app: SBMusicApplication) {
        self.player = .music
        playbackState = PlaybackState(app.playerState)
        songName = app.currentTrack?.name ?? ""
        songId = "" //TODO
        artistName = app.currentTrack?.artist ?? ""
        albumName = app.currentTrack?.album ?? ""
        albumId = "" //TODO
    }

    init?(_ player: Player, _ app: SBSpotifyApplication) {
        self.player = .spotify
        playbackState = PlaybackState(app.playerState)
        songName = app.currentTrack?.name ?? ""
        songId = app.currentTrack?.id()?.components(separatedBy: ":").last ?? ""
        artistName = app.currentTrack?.artist ?? ""
        albumName = app.currentTrack?.album ?? ""
        albumId = nil
    }

    init?(_ player: Player, _ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        self.player = player
        self.playbackState = PlaybackState(playbackStateString)
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
