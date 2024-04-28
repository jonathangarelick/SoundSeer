import OSLog

// https://www.avanderlee.com/debugging/oslog-unified-logging/
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let api = Logger(subsystem: subsystem, category: "api")
    static let config = Logger(subsystem: subsystem, category: "config")
    static let model = Logger(subsystem: subsystem, category: "model")
    static let playback = Logger(subsystem: subsystem, category: "playback")
    static let view = Logger(subsystem: subsystem, category: "view")
}
