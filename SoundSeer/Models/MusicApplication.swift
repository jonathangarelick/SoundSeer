enum MusicApplication {
    static let bundleID = "com.apple.Music"
    static let app: SBMusicApplication? = SBApplicationManager.musicApp()

    static func getPlayerState() -> PlayerState? {
        guard let app = app, Utils.isAppRunning(bundleID) else { return nil }
        return PlayerState(.music, app)
    }
}
