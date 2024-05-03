import AppKit
import MusicKit
import OSLog
import ScriptingBridge

class PlayerModel {
    @Published var playerState: PlaybackState = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    private let spotifyApp: SpotifyApplication
    private let musicApp: MusicApplication = SBApplication(bundleIdentifier: "com.apple.Music")!

    private let notificationCenter = DistributedNotificationCenter.default()
    private let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    let musicNotificationName = Notification.Name("com.apple.Music.playerInfo")

    init?() {
        guard let spotifyApp = SBApplication(bundleIdentifier: "com.spotify.client") else {
            Logger.model.error("Could not find Spotify application")
            return nil
        }

        self.spotifyApp = spotifyApp

        // Need to trigger a "fake" event when SoundSeer is first opened
//        Logger.model.debug("Performing initial update")
//        update()

        Logger.model.debug("Subscribing to Spotify playback change events")
        notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] in
            self?.update(PlayerStateNotification(.spotify, $0))
        }

        Logger.model.debug("Subscribing to Apple Music playback change events")
        notificationCenter.addObserver(forName: musicNotificationName, object: nil, queue: nil) { [weak self] in
            self?.update(PlayerStateNotification(.music, $0))
        }
    }

    deinit {
        Logger.model.debug("Removing subscription to Spotify playback events")
        DistributedNotificationCenter.default().removeObserver(self)
    }

    func nextTrack() {
        Logger.model.debug("Skipping track")
        spotifyApp.nextTrack?()
    }

    private func resetData() {
        Logger.model.debug("Resetting data")
        playerState = .stopped

        currentSong = ""
        currentSongId = ""
        currentArtist = ""
        currentAlbum = ""
    }

    private func update(_ notification: PlayerStateNotification?) {
        guard let notification = notification else {
            Logger.model.error("Received bad event. Discarding")
            return
        }

        playerState = notification.playbackState
        Logger.playback.debug("Player state is now \(String(describing: self.playerState))")

        currentSong = notification.songName ?? ""
        currentSongId = "abc" //spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = notification.artistName ?? ""
        currentAlbum = notification.albumName ?? ""

        Logger.model.debug("Retrieved current song: \(self.currentSong, privacy: .public)")
        Logger.model.debug("Retrieved current song ID: \(self.currentSongId, privacy: .public)")
        Logger.model.debug("Retrieved current artist: \(self.currentArtist, privacy: .public)")
        Logger.model.debug("Retrieved current album: \(self.currentAlbum, privacy: .public)")

        Logger.model.debug("Update completed successfully")

        /*
        // Sometimes the AEKeyword will be 0 when the app is killed
        // Something about the Objective-C bridge allows the enum to still be created
        if Utils.playerStateIsStoppedOrUnknown(playerState) {
            Logger.playback.debug("Cancelled update. Player in stopped or unknown state")
            resetData()
            return
        }



        // I have no idea why this sometimes happens. It's only for artist
        if currentArtist.isEmpty {
            Logger.model.log("Current artist is empty. Retrying...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.currentArtist = self?.spotifyApp.currentTrack?.artist ?? ""
                Logger.model.log("Second attempt to retrieve current artist: \(self?.currentArtist ?? "nil", privacy: .public)")
            }
        }

        currentAlbum = spotifyApp.currentTrack?.album ?? ""




         */
    }
}
