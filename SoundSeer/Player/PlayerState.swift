import Foundation

struct PlayerState {
    let album: String?
    let albumID: String?
    let artist: String?
    let playbackState: PlaybackState
    let song: String?
    let songID: String?

    init(_ app: SBMusicApplication) {
        album = app.currentTrack?.album
        albumID = nil
        artist = app.currentTrack?.artist
        playbackState = PlaybackState(app.playerState)
        song = app.currentTrack?.name
        songID = nil
    }

    init(_ app: SBSpotifyApplication) {
        album = app.currentTrack?.album
        albumID = nil
        artist = app.currentTrack?.artist
        playbackState = PlaybackState(app.playerState)
        song = app.currentTrack?.name
        songID = app.currentTrack?.id()?.components(separatedBy: ":").last
    }

    init?(_ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        album = notification.userInfo?["Album"] as? String
        artist = notification.userInfo?["Artist"] as? String
        playbackState = PlaybackState(playbackStateString)
        song = notification.userInfo?["Name"] as? String

        switch notification.name {
        case Notification.Name("com.apple.Music.playerInfo"):
            let queryItems = URLComponents(
                string: notification.userInfo?["Store URL"] as? String ?? ""
            )?.queryItems

            albumID = queryItems?.first(where: { $0.name == "p" })?.value
            songID = queryItems?.first(where: { $0.name == "i" })?.value
        case Notification.Name("com.spotify.client.PlaybackStateChanged"):
            albumID = nil
            songID = (notification.userInfo?["Track ID"] as? String)?.components(separatedBy: ":").last
        default:
            return nil
        }
    }
}
