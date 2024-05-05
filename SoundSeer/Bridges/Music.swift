import ScriptingBridge

@objc public enum MusicEPlS : AEKeyword {
    case stopped = 0x6b505353 /* 'kPSS' */
    case playing = 0x6b505350 /* 'kPSP' */
    case paused = 0x6b505370 /* 'kPSp' */
    case fastForwarding = 0x6b505346 /* 'kPSF' */
    case rewinding = 0x6b505352 /* 'kPSR' */
}

@objc public protocol MusicApplication {
    @objc optional var currentTrack: MusicTrack { get }
    @objc optional func nextTrack()
}
extension SBApplication: MusicApplication {}

@objc public protocol MusicTrack {
    @objc optional var name: String { get }
    @objc optional var artist: String { get }
    @objc optional var album: String { get }
    @objc optional func reveal()
}
extension SBObject: MusicTrack {}
