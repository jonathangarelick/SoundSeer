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

    init(_ state: SBAppleMusicEPlS) {
        switch state {
        case SBAppleMusicEPlSPaused:
            self = .paused
        case SBAppleMusicEPlSRewinding, SBAppleMusicEPlSPlaying, SBAppleMusicEPlSFastForwarding:
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
