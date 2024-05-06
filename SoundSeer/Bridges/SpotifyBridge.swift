import ScriptingBridge

@objc public enum SpotifyEPlS : AEKeyword {
    case stopped = 0x6b505353 /* 'kPSS' */
    case playing = 0x6b505350 /* 'kPSP' */
    case paused = 0x6b505370 /* 'kPSp' */
}

@objc public protocol SpotifyApplication {
    @objc optional var playerState: SpotifyEPlS { get }
    @objc optional var currentTrack: SpotifyTrack { get }
    @objc optional func nextTrack()
}
extension SBApplication: SpotifyApplication {}

@objc public protocol SpotifyTrack {
    @objc optional var name: String { get }
    @objc optional var artist: String { get }
    @objc optional var album: String { get }

    // Might need these in the future
    @objc optional var spotifyUrl: String { get }
    @objc optional func id() -> String
    @objc optional func setSpotifyUrl(_ spotifyUrl: String!)
}
extension SBObject: SpotifyTrack {}
