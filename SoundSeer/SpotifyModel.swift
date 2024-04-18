import ScriptingBridge

class SpotifyModel {
    let spotifyApp: SpotifyApplication = SBApplication(bundleIdentifier: "com.spotify.client")!

    let notificationCenter = DistributedNotificationCenter.default()
    let notificationName = Notification.Name("com.spotify.client.PlaybackStateChanged")

    @Published var isApplicationRunning: Bool = false
    @Published var playerState: SpotifyEPlS = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    init() {
        notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { [weak self] _ in
            self?.update()
        }
    }

    deinit { DistributedNotificationCenter.default().removeObserver(self) }

    func update() {
        isApplicationRunning = spotifyApp.isRunning ?? false
        playerState = spotifyApp.playerState ?? .stopped

        currentSong = spotifyApp.currentTrack?.name ?? ""
        currentSongId = spotifyApp.currentTrack?.id?().components(separatedBy: ":").last ?? ""
        currentArtist = spotifyApp.currentTrack?.artist ?? ""
        currentAlbum = spotifyApp.currentTrack?.album ?? ""
    }
}
