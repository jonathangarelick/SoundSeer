import AppKit
import Combine
import Foundation
import ScriptingBridge

class AppleMusicPlayer: Player {
    static let shared: AppleMusicPlayer? = AppleMusicPlayer()
    
    let bundleIdentifier: String = "com.apple.Music"
    
    var canCopySongExternalURL: Bool {
        guard playbackState != .stopped, let songId = playerState?.songID, let albumId = playerState?.albumID else { return false }
        return !songId.isEmpty && !albumId.isEmpty
    }
    
    var canRevealSong: Bool {
        playbackState != .stopped
    }
    
    var playerState: PlayerState? {
        subject.value
    }
    
    let sbReference: SBMusicApplication
    let subject = CurrentValueSubject<PlayerState?, Never>(nil)
    
    init?() {
        guard let applicationReference = SBApplicationManager.musicApp() else { return nil }
        self.sbReference = applicationReference
        
        if isRunning() {
            subject.send(PlayerState(applicationReference))
        }
        
        DistributedNotificationCenter.default().addObserver(
            forName: Notification.Name("com.apple.Music.playerInfo"), object: nil, queue: nil) { [weak self] in
                self?.subject.send(PlayerState($0))
            }
    }
    
    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    func copySongExternalURL() {
        guard let songId = playerState?.songID, let albumId = playerState?.albumID else { return }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString("https://music.apple.com/album/\(albumId)?i=\(songId)", forType: .string)
    }
    
    func nextTrack() {
        sbReference.nextTrack()
    }
    
    func revealAlbum() {
        guard let songId = playerState?.songID else { return }
        MusicAPI.getURI(songId: songId, for: .album) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
    
    func revealArtist() {
        guard let songId = playerState?.songID else { return }
        MusicAPI.getURI(songId: songId, for: .artist) { uri in
            if let uri = uri {
                NSWorkspace.shared.open(uri)
            }
        }
    }
    
    func revealSong() {
        sbReference.currentTrack?.reveal()
        sbReference.activate() // Reveal does not bring the app to the foreground
    }
}
