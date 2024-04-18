import AppKit
import ScriptingBridge

class SpotifyModel {
    @Published var playerState: SpotifyEPlSTyped = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    private let spotifyApp: SpotifyApplication = SBApplication(bundleIdentifier: "com.spotify.client")!

    private let notificationCenter = DistributedNotificationCenter.default()
    private let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    init() {
        // Need to trigger a "fake" event when SoundSeer is first opened
        update()

        notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] _ in
            self?.update()
        }
    }

    deinit { DistributedNotificationCenter.default().removeObserver(self) }

    private func resetData() {
        playerState = .stopped

        currentSong = ""
        currentSongId = ""
        currentArtist = ""
        currentAlbum = ""
    }

    private func update() {
        if !(spotifyApp.isRunning ?? false) {
            resetData()
            return
        }

        // This will open the app if it is closed, so we need to check isRunning first
        playerState = spotifyApp.playerState ?? .stopped

        // Sometimes the AEKeyword will be 0 when the app is killed
        // Something about the Objective-C bridge allows the enum to still be created
        if playerState != .paused && playerState != .playing {
            resetData()
            return
        }

        currentSong = spotifyApp.currentTrack?.name ?? ""
        currentSongId = spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = spotifyApp.currentTrack?.artist ?? ""
        currentAlbum = spotifyApp.currentTrack?.album ?? ""
    }
}
