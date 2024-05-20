import Combine
import Foundation

class PlayerService {
    static let shared: PlayerService? = PlayerService()

    private let appleMusicPlayer: AppleMusicPlayer? = AppleMusicPlayer.shared
    private let spotifyPlayer: SpotifyPlayer? = SpotifyPlayer.shared
    
    let currentPlayerSubject = PassthroughSubject<Player?, Never>()
    private(set) var currentPlayer: Player? {
        didSet {
            currentPlayerSubject.send(currentPlayer)
        }
    }

    private init?() {
        if appleMusicPlayer == nil && spotifyPlayer == nil {
            return nil
        }

        if appleMusicPlayer == nil {
            currentPlayer = spotifyPlayer
        } else if spotifyPlayer == nil {
            currentPlayer = appleMusicPlayer
        } else if spotifyPlayer?.playbackState == .playing, appleMusicPlayer?.playbackState == .playing {
            currentPlayer = appleMusicPlayer
        } else {
            currentPlayer = spotifyPlayer?.playbackState == .playing ? spotifyPlayer : appleMusicPlayer
        }

        NotificationCenter.default.addObserver(forName: .ssCurrentPlayerChanged, object: nil, queue: nil) { [weak self] in
            guard let currentPlayer = $0.object as? Player else { return }
            self?.currentPlayer = currentPlayer
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
