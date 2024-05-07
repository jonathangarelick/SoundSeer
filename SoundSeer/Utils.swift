import AppKit

enum Utils {
    static func isAppInstalled(_ bundleIdentifier: String) -> Bool {
        let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleIdentifier)
        return url != nil
    }
    
    static func isAppRunning(_ bundleIdentifier: String) -> Bool {
        return NSWorkspace.shared.runningApplications
            .filter { $0.bundleIdentifier == bundleIdentifier }.count > 0
    }
}
