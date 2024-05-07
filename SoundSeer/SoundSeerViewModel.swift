import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI

class SoundSeerViewModel: ObservableObject {
    let model: SoundSeerModel? = SoundSeerModel()

    @Published var playerState: PlayerState?

    var currentSong: String? {
        playerState?.songName ?? ""
    }

    var currentSongId: String {
        playerState?.songId ?? ""
    }

    var currentArtist: String {
        playerState?.artistName ?? ""
    }

    var currentAlbum: String {
        playerState?.albumName ?? ""
    }

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $isAppVisibleInMenuBar
            .sink { [weak self] in
                self?.handleVisibilityChange($0)
            }
            .store(in: &cancellables)
        
        model?.$playerState
            .assign(to: \.playerState, on: self)
            .store(in: &cancellables)
    }
    
    deinit { timer?.invalidate() }

    func nextTrack() {
//        currentApplication?.nextTrack()
    }

    func openCurrentSong() {
//        currentApplication?.revealSong()
    }
    
    func openCurrentArtist() {
//        currentApplication?.revealArtist()
    }

    func openCurrentAlbum() {
//        currentApplication?.revealAlbum()
    }

    func copySongExternalURL() {
//        currentApplication?.copySongURL()
    }

    // MARK: - Dynamic resizing
    @Published var isAppVisibleInMenuBar: Bool = false // This will trigger dynamic resizing on startup, just to be safe
    @Published var prefixLength = 45
    
    private var timer: Timer?
    
    var nowPlaying: String {
        get {
            if currentSong.isEmpty || currentArtist.isEmpty {
                return ""
            } else {
                return "\(currentSong.prefixBefore("(")) · \(currentArtist)".truncate(length: prefixLength)
            }
        }
    }
    
    // https://stackoverflow.com/a/77304045
    private static func isAppInMenuBar(_ appName: String) -> Bool {
        let processNamesWithStatusItems = Set(
            (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary])
                .filter { $0[kCGWindowLayer] as! Int == 25 }
                .map { $0[kCGWindowOwnerName] as! String }
        )
        
        return processNamesWithStatusItems.contains(appName)
    }
    
    private func handleVisibilityChange(_ isVisible: Bool) {
        timer?.invalidate()
        
        if playerState?.playbackState == .playing, !isVisible, !Self.isAppInMenuBar("SoundSeer") {
            doDynamicResizing()
        }
    }
    
    private func doDynamicResizing() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard self.prefixLength > 0 else {
                Logger.view.debug("Prefix length is not positive, dynamic resizing stopped")
                timer.invalidate()
                return
            }
            
            Logger.view.debug("Current prefix length is \(self.prefixLength), decreasing by 5")
            self.prefixLength -= 5
        }
    }
}
