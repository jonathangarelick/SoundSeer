import OSLog

// https://www.avanderlee.com/debugging/oslog-unified-logging/
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let model = Logger(subsystem: subsystem, category: "model")
    static let playback = Logger(subsystem: subsystem, category: "playback")
}
