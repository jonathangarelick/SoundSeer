import Foundation
import ScriptingBridge

// https://majestysoftware.wordpress.com/2015/03/31/swift-scripting-part-1/

// The AppleScript strings are the same, just lowercase
enum PlayerState: String {
    case playing = "Playing"
    case paused = "Paused"
    case stopped = "Stopped"
}

class SpotifyModel {
    @Published var isApplicationRunning: Bool = false
    @Published var playerState: PlayerState = .stopped

    @Published var currentSong: String = ""
    @Published var currentSongId: String = ""
    @Published var currentArtist: String = ""
    @Published var currentAlbum: String = ""

//    var spotifyApp: SpotifyApplication?

    let script = NSAppleScript(source: """
        (*

        OUTPUT FORMAT:
        [1] isApplicationRunning: Bool
        [2] playerState: String
        [3] currentSong: String
        [4] currentSongId: String
        [5] currentArtist: String
        [6] currentAlbum: String

        *)
        tell application "Spotify"
            if it is not running then
                return {false}
            end if

            return {true, player state as text, name of current track, id of current track, artist of current track, album of current track}
        end tell
    """)

    init() {
        let spotifyApp: AnyObject = SBApplication(bundleIdentifier: "com.spotify.client")!
        firstUpdate()
    }

    deinit { DistributedNotificationCenter.default().removeObserver(self) }

    func firstUpdate() {
        // https://developer.apple.com/documentation/foundation/nsapplescript/error_dictionary_keys
        // https://developer.apple.com/library/archive/documentation/AppleScript/Conceptual/AppleScriptLangGuide/reference/ASLR_error_codes.html
        // Handle this later, if ever
        var error: NSDictionary?

        DispatchQueue.global().async { [self] in
            let result = script?.executeAndReturnError(&error)

            DispatchQueue.main.async { [self] in
                if let result = result {
                    isApplicationRunning = result.atIndex(1)?.booleanValue ?? false
                    playerState = PlayerState(rawValue: result.atIndex(2)?.stringValue?.capitalized ?? "Stopped") ?? .stopped
                    currentSong = result.atIndex(3)?.stringValue ?? ""
                    currentSongId = result.atIndex(4)?.stringValue?.components(separatedBy: ":").last ?? ""
                    currentArtist = result.atIndex(5)?.stringValue ?? ""
                    currentAlbum = result.atIndex(6)?.stringValue ?? ""
                }

                DistributedNotificationCenter.default().addObserver(self, selector: #selector(handlePlaybackStateChanged(_:)), name: Notification.Name("com.spotify.client.PlaybackStateChanged"), object: nil)
            }
        }
    }

    @objc func handlePlaybackStateChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            // These are swapped around to be concise
            playerState = PlayerState(rawValue: userInfo["Player State"] as? String ?? "") ?? .stopped
            isApplicationRunning = playerState != .stopped

            currentSong = userInfo["Name"] as? String ?? ""
            currentSongId = (userInfo["Track ID"] as? String)?.components(separatedBy: ":").last ?? ""
            currentArtist = userInfo["Artist"] as? String ?? ""
            currentAlbum = userInfo["Album"] as? String ?? ""
        }
    }
}

//@objc public protocol SBObjectProtocol: NSObjectProtocol {
//    func get() -> Any!
//}
//@objc public protocol SBApplicationProtocol: SBObjectProtocol {
//    func activate()
//    var delegate: SBApplicationDelegate! { get set }
//    @objc optional var isRunning: Bool { get }
//}

//@objc public protocol SpotifyApplication: SBApplicationProtocol {
//    @objc optional var currentTrack: SpotifyTrack { get } // The current playing track.
//}
//extension SBApplication: SpotifyApplication {}
//
//
//@objc public protocol SpotifyTrack: SBObjectProtocol {
//    @objc optional var name: String { get } // The name of the track.
//}
//extension SBObject: SpotifyTrack {}
