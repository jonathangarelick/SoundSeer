import Foundation

class NotificationService {
    static let shared = NotificationService()
    
    private init() {
        observe()
    }
    
    private func observe() {
        DistributedNotificationCenter.default().addObserver(forName: .appleMusicPlaybackStateChanged, object: nil, queue: nil) { [weak self] in
            self?.broadcastPlayerState(PlayerState(.music, $0))
        }
        
        DistributedNotificationCenter.default().addObserver(forName: .spotifyPlaybackStateChanged, object: nil, queue: nil) { [weak self] in
            self?.broadcastPlayerState(PlayerState(.spotify, $0))
        }
        
        NotificationCenter.default.addObserver(forName: NSWindow.didChangeOcclusionStateNotification, object: nil, queue: nil) { [weak self] in
            self?.broadcastOcclusionState($0.object as? NSWindow)
        }
    }
    
    private func broadcastPlayerState(_ playerState: PlayerState?) {
        guard let playerState = playerState else { return }
        NotificationCenter.default.post(name: .ssPlayerStateChanged, object: nil, userInfo: ["playerState": playerState])
    }
    
    private func broadcastOcclusionState(_ window: NSWindow?) {
        guard let window = window, window.className == "NSStatusBarWindow" else { return }
        NotificationCenter.default.post(name: .ssOcclusionStateChanged, object: nil, userInfo: ["occlusionState": window.occlusionState])
    }
}

extension Notification.Name {
    static let appleMusicPlaybackStateChanged = Notification.Name("com.apple.Music.playerInfo")
    static let spotifyPlaybackStateChanged = Notification.Name("com.spotify.client.PlaybackStateChanged")
    static let ssOcclusionStateChanged = Notification.Name("net.garelick.SoundSeer.OcclusionStateChanged")
    static let ssPlayerStateChanged = Notification.Name("net.garelick.SoundSeer.PlayerStateChanged")
}
