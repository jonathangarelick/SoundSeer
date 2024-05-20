import AppKit
import Foundation
import ScriptingBridge

class PlayerState {
    let player: PlayerType
    let playbackState: PlaybackState
    let songName: String?
    let songId: String?
    let artistName: String?
    let albumName: String?
    let albumId: String?
    let timestamp = Date()

//    init?(_ player: PlayerType, _ app: SBApplication) {
//        switch player {
//        case .appleMusic:
//            guard let app = app as? SBMusicApplication else { return nil }
//            self.player = .appleMusic
//            playbackState = PlaybackState(app.playerState)
//            songName = app.currentTrack?.name ?? ""
//            songId = "" //TODO
//            artistName = app.currentTrack?.artist ?? ""
//            albumName = app.currentTrack?.album ?? ""
//            albumId = "" //TODO
//        case .spotify:
//            guard let app = app as? SBSpotifyApplication else { return nil }
//            self.player = .spotify
//            playbackState = PlaybackState(app.playerState)
//            songName = app.currentTrack?.name ?? ""
//            songId = app.currentTrack?.id()?.components(separatedBy: ":").last ?? ""
//            artistName = app.currentTrack?.artist ?? ""
//            albumName = app.currentTrack?.album ?? ""
//            albumId = nil
//        }
//    }

    // If the two SBApplication initializers are combined, compilation fails. Not sure why
    init?(_ player: PlayerType, _ app: SBMusicApplication) {
        self.player = .appleMusic
        playbackState = PlaybackState(app.playerState)
        songName = app.currentTrack?.name ?? ""
        songId = "" //TODO
        artistName = app.currentTrack?.artist ?? ""
        albumName = app.currentTrack?.album ?? ""
        albumId = "" //TODO
    }

    init?(_ player: PlayerType, _ app: SBSpotifyApplication) {
        self.player = .spotify
        playbackState = PlaybackState(app.playerState)
        songName = app.currentTrack?.name ?? ""
        songId = app.currentTrack?.id()?.components(separatedBy: ":").last ?? ""
        artistName = app.currentTrack?.artist ?? ""
        albumName = app.currentTrack?.album ?? ""
        albumId = nil
    }

    init?(_ player: PlayerType, _ notification: Notification) {
        guard let playbackStateString = notification.userInfo?["Player State"] as? String else {
            return nil
        }

        self.player = player
        self.playbackState = PlaybackState(playbackStateString)
        self.songName = notification.userInfo?["Name"] as? String

        switch player {
        case .appleMusic:
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
