import Foundation
import OSLog

class SoundSeerModel {
    @Published var playerState: PlayerState?

    init?() {
        if !Utils.isAppInstalled(MusicApplication.bundleID),
           !Utils.isAppInstalled(SpotifyApplication.bundleID) {
            Logger.model.error("Could not find Apple Music or Spotify application")
            return nil
        }

        playerState = getPlayerState()

        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.apple.Music.playerInfo"), object: nil, queue: nil) { [weak self] in
                self?.playerState = PlayerState(.music, $0)
            }

        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { [weak self] in
                self?.playerState = PlayerState(.spotify, $0)
            }
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    func getPlayerState() -> PlayerState? {
        let musicState = MusicApplication.getPlayerState()
        let spotifyState = SpotifyApplication.getPlayerState()
        
        if (spotifyState?.playbackState == .playing && (musicState == nil || musicState?.playbackState != .playing))
            || (spotifyState?.playbackState != .playing && musicState == nil)
            || ((spotifyState?.playbackState == .paused || spotifyState?.playbackState == .playing) && musicState?.playbackState == .stopped) {
            return spotifyState
        }
        
        return musicState
    }
}
