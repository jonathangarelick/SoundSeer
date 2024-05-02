enum Utils {
    static func isAppRunning(_ bundleIdentifier: String) -> Bool {
        return NSWorkspace.shared.runningApplications
            .filter { $0.bundleIdentifier == bundleIdentifier }.count > 0
    }

    static func playerStateIsStoppedOrUnknown(_ playerState: PlaybackState) -> Bool {
        return playerState != .paused && playerState != .playing
    }
}
