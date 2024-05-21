import Foundation

class NotificationService {
    static let shared = NotificationService()

    private init() {
        addObservers()
    }

    deinit {
        removeObservers()
    }

    private func addObservers() {
        DistributedNotificationCenter.default().addObserver(
            forName: .appleMusicPlaybackStateChanged, object: nil, queue: nil) { notification in
                guard let playerState = PlayerState(.appleMusic, notification) else { return }
                NotificationCenter.default.post(name: .ssCurrentPlayerChanged, object: AppleMusicPlayer.shared)
                NotificationCenter.default.post(name: .ssAppleMusicStateChanged, object: nil, userInfo: ["playerState": playerState])
                NotificationCenter.default.post(name: .ssPlaybackStateChanged, object: AppleMusicPlayer.shared, userInfo: ["playbackState": playerState.playbackState])
        }

        DistributedNotificationCenter.default().addObserver(
            forName: .spotifyPlaybackStateChanged, object: nil, queue: nil) { notification in
                guard let playerState = PlayerState(.spotify, notification) else { return }
                NotificationCenter.default.post(name: .ssCurrentPlayerChanged, object: SpotifyPlayer.shared)
                NotificationCenter.default.post(name: .ssSpotifyStateChanged, object: nil, userInfo: ["playerState": playerState])
                NotificationCenter.default.post(name: .ssPlaybackStateChanged, object: SpotifyPlayer.shared, userInfo: ["playbackState": playerState.playbackState])
        }

        NotificationCenter.default.addObserver(
            forName: NSWindow.didChangeOcclusionStateNotification, object: nil, queue: nil) { notification in
            guard let window = notification.object as? NSWindow, window.className == "NSStatusBarWindow" else { return }
            NotificationCenter.default.post(name: .ssOcclusionStateChanged, object: nil, userInfo: ["occlusionState": window.occlusionState])
        }
    }

    private func removeObservers() {
        DistributedNotificationCenter.default().removeObserver(self)
        NotificationCenter.default.removeObserver(self)
    }
}

extension Notification.Name {
    static let appleMusicPlaybackStateChanged = Notification.Name("com.apple.Music.playerInfo")
    static let spotifyPlaybackStateChanged = Notification.Name("com.spotify.client.PlaybackStateChanged")

    static let ssAppleMusicStateChanged = Notification.Name("net.garelick.SoundSeer.AppleMusicStateChanged")
    static let ssSpotifyStateChanged = Notification.Name("net.garelick.SoundSeer.SpotifyStateChanged")
    static let ssOcclusionStateChanged = Notification.Name("net.garelick.SoundSeer.OcclusionStateChanged")
    static let ssCurrentPlayerChanged = Notification.Name("net.garelick.SoundSeer.CurrentPlayerChanged")

    static let ssPlaybackStateChanged = Notification.Name("net.garelick.SoundSeer.PlaybackStateChanged")
}
