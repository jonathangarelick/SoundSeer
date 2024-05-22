import Combine
import Foundation

class PlayerService {
    static let shared: PlayerService? = PlayerService()
    let currentPlayerSubject: CurrentValueSubject<Player?, Never>

    private let appleMusicPlayer: AppleMusicPlayer? = AppleMusicPlayer.shared
    private let spotifyPlayer: SpotifyPlayer? = SpotifyPlayer.shared

    var cancellables = Set<AnyCancellable>()

    private init?() {
        if appleMusicPlayer == nil && spotifyPlayer == nil {
            return nil
        }

        var currentPlayer: Player?

        if appleMusicPlayer == nil || appleMusicPlayer?.playerState == nil {
            currentPlayer = spotifyPlayer
        } else if spotifyPlayer == nil || spotifyPlayer?.playerState == nil {
            currentPlayer = appleMusicPlayer
        } else if spotifyPlayer?.playbackState == .playing, appleMusicPlayer?.playbackState != .playing {
            currentPlayer = spotifyPlayer
        } else {
            currentPlayer = appleMusicPlayer
        }

        currentPlayerSubject = CurrentValueSubject(currentPlayer)

        NotificationService.shared.playerStateSubject
            .compactMap { $0 }
            .sink { [weak self] in
                guard let self = self else { return }
                currentPlayerSubject.send($0.player == .appleMusic ? appleMusicPlayer : spotifyPlayer)
            }
            .store(in: &cancellables)
    }
}
