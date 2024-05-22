import Combine

class CurrentPlayerService {
    static let shared = CurrentPlayerService()

    let subject = CurrentValueSubject<Player?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init() {
        subject.send(getCurrentPlayer())

        AppleMusicPlayer.shared?.playerStateSubject
            .sink { [weak self] _ in
                self?.subject.send(AppleMusicPlayer.shared)
            }
            .store(in: &cancellables)

        SpotifyPlayer.shared?.playerStateSubject
            .sink { [weak self] _ in
                self?.subject.send(SpotifyPlayer.shared)
            }
            .store(in: &cancellables)
    }

    private func getCurrentPlayer() -> Player? {
        let appleMusicPlayer = AppleMusicPlayer.shared, spotifyPlayer = SpotifyPlayer.shared

        if appleMusicPlayer == nil || appleMusicPlayer?.playerState == nil {
            return spotifyPlayer
        } else if spotifyPlayer == nil || spotifyPlayer?.playerState == nil {
            return appleMusicPlayer
        } else if spotifyPlayer?.playbackState == .playing, appleMusicPlayer?.playbackState != .playing {
            return spotifyPlayer
        } else {
            return appleMusicPlayer
        }
    }
}
