import Foundation

class SpotifyModel {
    /*
     POSSIBLE VALUES FOR OUTPUT:
     
     "Spotify is not running"
     "Failed to fetch song"
     "${song}"

     */
    func getCurrentSong(completion: @escaping (String) -> Void) {
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

        DispatchQueue.global().async {
            let appleScript = NSAppleScript(source: script)
            var error: NSDictionary?
            let output = appleScript?.executeAndReturnError(&error).stringValue

            DispatchQueue.main.async {
                completion(output ?? "Failed to fetch song")
            }
        }
    }
}
