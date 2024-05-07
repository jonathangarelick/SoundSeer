enum PlaybackState {
    case paused
    case playing
    case stopped

    init(_ state: String) {
        switch state {
        case "Paused":
            self = .paused
        case "Playing":
            self = .playing
        default:
            self = .stopped
        }
    }

    init(_ state: SBMusicEPlS) {
        switch state {
        case SBMusicEPlSPaused:
            self = .paused
        case SBMusicEPlSRewinding, SBMusicEPlSPlaying, SBMusicEPlSFastForwarding:
            self = .playing
        default:
            self = .stopped
        }
    }
    
    init(_ state: SBSpotifyEPlS) {
        switch state {
        case SBSpotifyEPlSPaused:
            self = .paused
        case SBSpotifyEPlSPlaying:
            self = .playing
        default:
            self = .stopped
        }
    }
}
