import CoreGraphics

enum Utils {
    enum MenuBarApplication: String {
        case soundSeer = "SoundSeer"
    }

    // https://stackoverflow.com/a/77304045
    static func isAppInMenuBar(_ app: MenuBarApplication) -> Bool {
        let processNamesWithStatusItems = Set(
            (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary])
                .filter { $0[kCGWindowLayer] as! Int == 25 }
                .map { $0[kCGWindowOwnerName] as! String }
        )

        return processNamesWithStatusItems.contains(app.rawValue)
    }
}
