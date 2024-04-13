import Foundation

class SpotifyModel {
    @Published var currentSong: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""
    @Published var currentSongId: String = ""

    func update() {
        let script = NSAppleScript(source: """
            tell application "Spotify"
                if it is running then
                    set currentTrack to name of current track
                    set currentArtist to artist of current track
                    set currentAlbum to album of current track
                    return {currentTrack, currentArtist, currentAlbum, id of current track}
                else
                    return {"Spotify is not running", "", "", ""}
                end if
            end tell
        """)
        var error: NSDictionary?

        DispatchQueue.global().async {
            let result = script?.executeAndReturnError(&error)

            DispatchQueue.main.async { [self] in
                if let result = result {
                    currentSong = result.atIndex(1)?.stringValue ?? ""
                    currentArtist = result.atIndex(2)?.stringValue ?? ""
                    currentAlbum = result.atIndex(3)?.stringValue ?? ""
                    currentSongId = result.atIndex(4)?.stringValue?.components(separatedBy: ":").last ?? ""
                } else {
                    currentSong = "AppleScript error"
                    currentArtist = ""
                    currentAlbum = ""
                    currentSongId = ""
                }
            }
        }
    }
}
