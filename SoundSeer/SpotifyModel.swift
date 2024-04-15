import Foundation

class SpotifyModel {
    @Published var isApplicationRunning: Bool = false
    @Published var isPlaying: Bool = false

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

    let script = NSAppleScript(source: """
        (*

        OUTPUT FORMAT:
        [1] isApplicationRunning: Bool
        [2] isPlaying: Bool
        [3] currentSong: String
        [4] currentSongId: String
        [5] currentArtist: String
        [6] currentAlbum: String

        *)
        tell application "Spotify"
            if it is not running then
                return {false}
            end if

            return {true, player state is playing, name of current track, id of current track, artist of current track, album of current track}
        end tell
    """)

    init() {
        // "Compiling scripts is relatively expensive"
        // https://forums.developer.apple.com/forums/thread/98830
        DispatchQueue.global().async { [self] in
            script?.compileAndReturnError(nil)
        }
    }

    func update() {
        // https://developer.apple.com/documentation/foundation/nsapplescript/error_dictionary_keys
        // https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_error_codes.html
        // Handle this later, if ever
        var error: NSDictionary?

        DispatchQueue.global().async { [self] in
            let result = script?.executeAndReturnError(&error)

            DispatchQueue.main.async { [self] in
                if let result = result {
                    isApplicationRunning = result.atIndex(1)?.booleanValue ?? false
                    isPlaying = result.atIndex(2)?.booleanValue ?? false
                    currentSong = result.atIndex(3)?.stringValue ?? ""
                    currentSongId = result.atIndex(4)?.stringValue?.components(separatedBy: ":").last ?? ""
                    currentArtist = result.atIndex(5)?.stringValue ?? ""
                    currentAlbum = result.atIndex(6)?.stringValue ?? ""
                }
            }
        }
    }
}
