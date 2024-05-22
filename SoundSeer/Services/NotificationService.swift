import Combine
import Foundation

class NotificationService {
    static let shared = NotificationService()

    let playerStateSubject = CurrentValueSubject<PlayerState?, Never>(nil)
    let isVisibleSubject = CurrentValueSubject<Bool, Never>(false)
    var cancellables = Set<AnyCancellable>()

    private init() {
        DistributedNotificationCenter.default().addObserver(forName: Notification.Name("com.apple.Music.playerInfo"), object: nil, queue: nil) { [weak self] in
            guard let playerState = PlayerState(.appleMusic, $0) else { return }
            self?.playerStateSubject.send(playerState)
        }

        DistributedNotificationCenter.default().addObserver(forName: Notification.Name("com.spotify.client.PlaybackStateChanged"), object: nil, queue: nil) { [weak self] in
            guard let playerState = PlayerState(.spotify, $0) else { return }
            self?.playerStateSubject.send(playerState)
        }

        NotificationCenter.default
            .publisher(for: NSWindow.didChangeOcclusionStateNotification)
            .compactMap { $0.object as? NSWindow }
            .filter { $0.className == "NSStatusBarWindow" }
            .map { $0.occlusionState.contains(.visible) }
            .assign(to: \.value, on: isVisibleSubject)
            .store(in: &cancellables)
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
}
