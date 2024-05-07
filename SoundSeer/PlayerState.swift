enum PlayerState {
    case paused
    case playing
    case stopped

    init<T: RawRepresentable>(_ descriptor: T?) where T.RawValue == UInt32 {
        switch descriptor?.rawValue {
        case 0x6b505370:
            self = .paused
        case 0x6b505350, 0x6b505352, 0x6b505346: // playing, rewinding, fast-forwarding
            self = .playing
        default:
            self = .stopped
        }
    }

    init(state: String) {
        switch state {
        case "Paused":
            self = .paused
        case "Playing":
            self = .playing
        default:
            self = .stopped
        }
    }
}
