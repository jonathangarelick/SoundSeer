import AppKit
import Combine
import Foundation
import OSLog
import SwiftUI

class PlayerViewModel: ObservableObject {
    @Published private(set) var currentApplication: Application?
    @Published private(set) var playerState: PlayerState = .stopped
    
    @Published private(set) var currentSong: String = ""
    @Published private(set) var currentSongId: String = ""
    @Published private(set) var currentArtist: String = ""
    @Published private(set) var currentAlbum: String = ""
    @Published private(set) var currentAlbumId: String = ""


    private let playerModel: PlayerModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init?() {
        guard let playerModel = PlayerModel() else {
            // Model handles logging
            return nil
        }

        self.playerModel = playerModel

        $isAppVisibleInMenuBar
            .sink { [weak self] in
                self?.handleVisibilityChange($0)
            }
            .store(in: &cancellables)
        
        playerModel.$currentApplication
            .assign(to: \.currentApplication, on: self)
            .store(in: &cancellables)

        // FIXED BUG (#26):
        // If the user manually clicks play on a song (while currently playing), Spotify will
        // send a stopped and playing event in rapid succession. This prevents the UI from flickering
        playerModel.$playerState
            .map { playerState -> AnyPublisher<PlayerState, Never> in
                if playerState == .stopped {
                    return Just(playerState)
                        .delay(for: .milliseconds(600), scheduler: DispatchQueue.main)
                        .eraseToAnyPublisher()
                } else {
                    return Just(playerState).eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .assign(to: \.playerState, on: self)
            .store(in: &cancellables)
        
        playerModel.$currentSong
            .assign(to: \.currentSong, on: self)
            .store(in: &cancellables)
        
        playerModel.$currentSongId
            .assign(to: \.currentSongId, on: self)
            .store(in: &cancellables)
        
        playerModel.$currentArtist
            .assign(to: \.currentArtist, on: self)
            .store(in: &cancellables)
        
        playerModel.$currentAlbum
            .assign(to: \.currentAlbum, on: self)
            .store(in: &cancellables)

        playerModel.$currentAlbumId
            .assign(to: \.currentAlbumId, on: self)
            .store(in: &cancellables)
    }
    
    deinit { timer?.invalidate() }

    func nextTrack() {
        currentApplication?.nextTrack()
    }

    func openCurrentSong() {
        currentApplication?.revealSong()
    }
    
    func openCurrentArtist() {
        currentApplication?.revealArtist()
    }

    func openCurrentAlbum() {
        currentApplication?.revealAlbum()
    }

    func copySongExternalURL() {
        currentApplication?.copySongURL()
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
        
        if playerState == .playing, !isVisible, !Self.isAppInMenuBar("SoundSeer") {
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
