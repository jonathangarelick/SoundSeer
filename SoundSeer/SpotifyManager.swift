import Foundation

class SpotifyManager: ObservableObject {
    @Published var currentSong: String = ""

    private var timer: Timer?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.getCurrentSong()
        }
    }

    private func getCurrentSong() {
        let script = """
        tell application "Spotify"
            if it is running then
                set currentTrack to name of current track
                set currentArtist to artist of current track
                return currentTrack & " - " & currentArtist
            else
                return "Spotify is not running"
            end if
        end tell
        """

        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let output = appleScript?.executeAndReturnError(&error).stringValue

        if let error = error {
            print("AppleScript error: \(error)")
            currentSong = "Error retrieving song"
        } else {
            currentSong = String(output?.prefix(25) ?? "NIL")
        }
    }
}
