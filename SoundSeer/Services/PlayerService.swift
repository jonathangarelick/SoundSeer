import Combine
import Foundation

class PlayerService {
    static let shared: PlayerService? = PlayerService()
    let currentPlayerSubject: CurrentValueSubject<Player?, Never>

    private let appleMusicPlayer: AppleMusicPlayer? = AppleMusicPlayer.shared
    private let spotifyPlayer: SpotifyPlayer? = SpotifyPlayer.shared

    private init?() {
        if appleMusicPlayer == nil && spotifyPlayer == nil {
            return nil
        }

        var currentPlayer: Player?

        if appleMusicPlayer == nil {
            currentPlayer = spotifyPlayer
        } else if spotifyPlayer == nil {
            currentPlayer = appleMusicPlayer
        } else if spotifyPlayer?.playbackState == .playing, appleMusicPlayer?.playbackState != .playing {
            currentPlayer = spotifyPlayer
        } else {
            currentPlayer = appleMusicPlayer
        }

        currentPlayerSubject = CurrentValueSubject(currentPlayer)

        NotificationCenter.default.addObserver(forName: .ssCurrentPlayerChanged, object: nil, queue: nil) { [weak self] in
            guard let currentPlayer = $0.object as? Player else { return }
            self?.currentPlayerSubject.send(currentPlayer)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
