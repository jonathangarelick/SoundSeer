import AppKit
import ScriptingBridge

// MARK: MusicEPlS
@objc public enum MusicEPlS : AEKeyword {
    case stopped = 0x6b505353 /* 'kPSS' */
    case playing = 0x6b505350 /* 'kPSP' */
    case paused = 0x6b505370 /* 'kPSp' */
    case fastForwarding = 0x6b505346 /* 'kPSF' */
    case rewinding = 0x6b505352 /* 'kPSR' */
}

// MARK: MusicGenericMethods
@objc public protocol MusicGenericMethods {}

// MARK: MusicApplication
@objc public protocol MusicApplication: SBApplicationProtocol {
    @objc optional var currentStreamTitle: String { get } // the name of the current song in the playing stream (provided by streaming server)
    @objc optional var currentStreamURL: String { get } // the URL of the playing stream or streaming web site (provided by streaming server)
    @objc optional var currentTrack: MusicTrack { get } // the current targeted track
    @objc optional var EQEnabled: Bool { get } // is the equalizer enabled?
    @objc optional var fixedIndexing: Bool { get } // true if all AppleScript track indices should be independent of the play order of the owning playlist.
    @objc optional var frontmost: Bool { get } // is Music the frontmost application?
    @objc optional var fullScreen: Bool { get } // are visuals displayed using the entire screen?
    @objc optional var name: String { get } // the name of the application
    @objc optional var mute: Bool { get } // has the sound output been muted?
    @objc optional var playerPosition: Double { get } // the player’s position within the currently playing track in seconds.
    @objc optional var playerState: MusicEPlS { get } // is Music stopped, paused, or playing?
    @objc optional var selection: SBObject { get } // the selection visible to the user
    @objc optional var soundVolume: Int { get } // the sound output volume (0 = minimum, 100 = maximum)
    @objc optional var version: String { get } // the version of Music
    @objc optional func run() // Run Music
    @objc optional func quit() // Quit Music
    @objc optional func add(_ x: [URL]!, to: SBObject!) -> MusicTrack // add one or more files to a playlist
    @objc optional func backTrack() // reposition to beginning of current track or go to previous track if already at start of current track
    @objc optional func fastForward() // skip forward in a playing track
    @objc optional func nextTrack() // advance to the next track in the current playlist
    @objc optional func pause() // pause playback
    @objc optional func playOnce(_ once: Bool) // play the current track or the specified track or file.
    @objc optional func playpause() // toggle the playing/paused state of the current track
    @objc optional func previousTrack() // return to the previous track in the current playlist
    @objc optional func resume() // disable fast forward/rewind and resume playback, if playing.
    @objc optional func rewind() // skip backwards in a playing track
    @objc optional func stop() // stop playback
}
extension SBApplication: MusicApplication {}

// MARK: MusicItem
@objc public protocol MusicItem: SBObjectProtocol, MusicGenericMethods {
    @objc optional func id() -> Int // the id of the item
    @objc optional var name: String { get } // the name of the item
}
extension SBObject: MusicItem {}

// MARK: MusicTrack
@objc public protocol MusicTrack: MusicItem {
    @objc optional var album: String { get } // the album name of the track
    @objc optional var albumArtist: String { get } // the album artist of the track
    @objc optional var artist: String { get } // the artist/source of the track
    @objc optional var composer: String { get } // the composer of the track
    @objc optional var loved: Bool { get } // is this track loved?
    @objc optional func setLoved(_ loved: Bool) // is this track loved?
}
extension SBObject: MusicTrack {}
