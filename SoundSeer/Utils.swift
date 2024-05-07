import AppKit

enum Utils {
    static func isAppRunning(_ bundleIdentifier: String) -> Bool {
        return NSWorkspace.shared.runningApplications
            .filter { $0.bundleIdentifier == bundleIdentifier }.count > 0
    }

    // https://stackoverflow.com/a/5320864
    private static let regex = try! NSRegularExpression(pattern: "(\\d+)(?!.*\\d)")

    static func getFinalNumber(from string: String) -> String? {
        let range = NSRange(location: 0, length: string.utf16.count)
        if let match = regex.firstMatch(in: string, options: [], range: range) {
            return (string as NSString).substring(with: match.range)
        }
        return nil
    }

    static func playerStateIsStoppedOrUnknown(_ playerState: PlayerState) -> Bool {
        return playerState != .paused && playerState != .playing
    }
}
