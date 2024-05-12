enum SpotifyApplication {
    static let bundleID = "com.spotify.client"
    static let app: SBSpotifyApplication? = SBApplicationManager.spotifyApp()

    static func getPlayerState() -> PlayerState? {
        guard let app = app else { return nil }
        return PlayerState(.spotify, app)
    }
}
