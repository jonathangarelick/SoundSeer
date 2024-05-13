enum SpotifyApplication {
    static let bundleID = "com.spotify.client"
    static let app: SBSpotifyApplication? = SBApplicationManager.spotifyApp()
    
    static func getPlayerState() -> PlayerState? {
        guard let app = app, Utils.isAppRunning(bundleID) else { return nil }
        return PlayerState(.spotify, app)
    }
}
