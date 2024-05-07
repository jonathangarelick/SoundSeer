import AppKit
import OSLog
import ScriptingBridge

class PlayerModel {
    @Published var currentApplication: Application?
    @Published var playerState: PlayerState = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""
    @Published var currentAlbumId: String = ""

    init?() {
        if !Utils.isAppInstalled(MusicApplication.bundleID),
           !Utils.isAppInstalled(SpotifyApplication.bundleID) {
            Logger.model.error("Could not find Apple Music or Spotify application")
            return nil
        }

        Logger.model.debug("Performing initial update")
        if Utils.isAppRunning(MusicApplication.bundleID) {
            doInitialUpdate(MusicApplication.shared)
        } else if Utils.isAppRunning(SpotifyApplication.bundleID) {
            doInitialUpdate(SpotifyApplication.shared)
        } else {
            Logger.model.debug("Neither app is running, waiting quietly...")
        }

        Logger.model.debug("Subscribing to Spotify playback change events")
        DistributedNotificationCenter.default().addObserver(forName: SpotifyApplication.notificationName, object: nil, queue: nil) { [weak self] in
            self?.update(PlayerStateNotification(SpotifyApplication.shared, $0))
        }

        Logger.model.debug("Subscribing to Apple Music playback change events")
        DistributedNotificationCenter.default().addObserver(forName: MusicApplication.notificationName, object: nil, queue: nil) { [weak self] in
            self?.update(PlayerStateNotification(MusicApplication.shared, $0))
        }
    }

    deinit {
        Logger.model.debug("Removing subscription to Spotify playback events")
        DistributedNotificationCenter.default().removeObserver(self)
    }

    private func resetData() {
        Logger.model.debug("Resetting data")
        playerState = .stopped

        currentSong = ""
        currentSongId = ""
        currentArtist = ""
        currentAlbum = ""
        currentAlbumId = ""
    }

    private func doInitialUpdate(_ application: Application) {
        currentApplication = application
        playerState = application.playerState
        // do more
    }

    private func update(_ notification: PlayerStateNotification?) {
        guard let notification = notification else {
            Logger.model.error("Received bad event. Discarding")
            return
        }

        currentApplication = notification.application

        playerState = notification.playerState
        Logger.playback.debug("Player state is now \(String(describing: self.playerState))")

        currentSong = notification.songName ?? ""
        currentSongId = notification.songId ?? ""
        
        // TODO: handle case when artist is sometimes empty on start
        currentArtist = notification.artistName ?? ""
        currentAlbum = notification.albumName ?? ""
        currentAlbumId = notification.albumId ?? ""

        Logger.model.debug("Retrieved current song: \(self.currentSong, privacy: .public)")
        Logger.model.debug("Retrieved current song ID: \(self.currentSongId, privacy: .public)")
        Logger.model.debug("Retrieved current artist: \(self.currentArtist, privacy: .public)")
        Logger.model.debug("Retrieved current album: \(self.currentAlbum, privacy: .public)")
        Logger.model.debug("Retrieved current album ID: \(self.currentAlbumId, privacy: .public)")

        Logger.model.debug("Update completed successfully")
    }
}
