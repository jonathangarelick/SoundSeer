import AppKit
import MusicKit
import OSLog
import ScriptingBridge

enum PlaybackState {
    case paused
    case playing
    case stopped

    init<T: RawRepresentable>(_ descriptor: T?) where T.RawValue == UInt32 {
        switch descriptor?.rawValue {
        case 0x6b505370:
            self = .paused
        case 0x6b505350, 0x6b505352, 0x6b505346: // playing, rewinding, fast-forwarding
            self = .playing
        default:
            self = .stopped
        }
    }
}

class PlayerModel {
    @Published var playerState: PlaybackState = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    private let spotifyApp: SpotifyApplication = SBApplication(bundleIdentifier: "com.spotify.client")!
    private let musicApp: MusicApplication = SBApplication(bundleIdentifier: "com.apple.Music")!

    private let notificationCenter = DistributedNotificationCenter.default()
    private let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    let musicNotificationName = Notification.Name("com.apple.Music.playerInfo")

    init() {
        notificationCenter.addObserver(forName: musicNotificationName, object: nil, queue: nil) { notification in
            // Handle the playback state change notification
            print("Received playback state change notification")

            // Extract the playback state information from the notification
            if let userInfo = notification.userInfo,
               let playerState = userInfo["Player State"] as? String {
                // Handle the player state
                print("Player State: \(playerState)")

                // Perform any necessary actions based on the player state
                // For example, update your app's UI or trigger specific behaviors
            }
        }

        // Need to trigger a "fake" event when SoundSeer is first opened
        Logger.model.debug("Performing initial update")
        update()

        Logger.model.debug("Subscribing to Spotify playback change events")
        notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] _ in
            self?.update()
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

    private func update() {
        // An event may be fired when Spotify is closed. This prevents it from reopening
        guard Utils.isAppRunning("com.spotify.client") else {
            Logger.playback.debug("Cancelled update. Spotify is not running")
            resetData()
            return
        }

        playerState = PlaybackState(spotifyApp.playerState)
        Logger.playback.debug("Player state is now \(String(describing: self.playerState))")

        // Sometimes the AEKeyword will be 0 when the app is killed
        // Something about the Objective-C bridge allows the enum to still be created
        if Utils.playerStateIsStoppedOrUnknown(playerState) {
            Logger.playback.debug("Cancelled update. Player in stopped or unknown state")
            resetData()
            return
        }

        currentSong = spotifyApp.currentTrack?.name ?? ""
        currentSongId = spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = spotifyApp.currentTrack?.artist ?? ""

        // I have no idea why this sometimes happens. It's only for artist
        if currentArtist.isEmpty {
            Logger.model.log("Current artist is empty. Retrying...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.currentArtist = self?.spotifyApp.currentTrack?.artist ?? ""
                Logger.model.log("Second attempt to retrieve current artist: \(self?.currentArtist ?? "nil", privacy: .public)")
            }
        }

        currentAlbum = spotifyApp.currentTrack?.album ?? ""

        Logger.model.debug("Retrieved current song: \(self.currentSong, privacy: .public)")
        Logger.model.debug("Retrieved current song ID: \(self.currentSongId, privacy: .public)")
        Logger.model.debug("Retrieved current artist: \(self.currentArtist, privacy: .public)")
        Logger.model.debug("Retrieved current album: \(self.currentAlbum, privacy: .public)")

        Logger.model.debug("Update completed successfully")
    }
}
