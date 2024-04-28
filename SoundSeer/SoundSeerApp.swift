import OSLog
import ServiceManagement
import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    
    @State private var isOpenAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled
    @State private var window: NSWindow?
    
    var body: some Scene {
        MenuBarExtra {
            if spotifyViewModel.playerState == .playing, spotifyViewModel.prefixLength <= 0 {
                Button("Not enough room for song. Try restarting.", systemImage: "exclamationmark.triangle", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            }
            
            Button("Next Track", systemImage: "forward.end", action: spotifyViewModel.nextTrack)
                .labelStyle(.titleAndIcon)
                .disabled(spotifyViewModel.playerState != .paused && spotifyViewModel.playerState != .playing)
            
            Divider()
            
            Button(!spotifyViewModel.currentSong.isEmpty
                   ? (spotifyViewModel.prefixLength > 0
                      ? spotifyViewModel.currentSong.truncate(length: Int(Double(spotifyViewModel.prefixLength) * 1.5))
                      : spotifyViewModel.currentSong.truncate(length: 60))
                   : "Song unknown", systemImage: "music.note", action: spotifyViewModel.openCurrentSong)
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)
            
            Button(!spotifyViewModel.currentArtist.isEmpty
                   ? (spotifyViewModel.prefixLength > 0
                      ? spotifyViewModel.currentArtist.truncate(length: Int(Double(spotifyViewModel.prefixLength) * 1.5))
                      : spotifyViewModel.currentArtist.truncate(length: 60))
                   : "Artist unknown", systemImage: "person", action: spotifyViewModel.openCurrentArtist)
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)
            
            Button(!spotifyViewModel.currentAlbum.isEmpty
                   ? (spotifyViewModel.prefixLength > 0
                      ? spotifyViewModel.currentAlbum.truncate(length: Int(Double(spotifyViewModel.prefixLength) * 1.5))
                      : spotifyViewModel.currentAlbum.truncate(length: 60))
                   : "Album unknown", systemImage: "opticaldisc", action: spotifyViewModel.openCurrentAlbum)
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)
            
            Divider()
            
            Button("Copy Spotify URL", systemImage: "doc.on.doc", action: spotifyViewModel.copySpotifyExternalURL)
                .labelStyle(.titleAndIcon)
                .disabled(spotifyViewModel.currentSongId.isEmpty)
            
            Divider()
            
            Button {
                // This is a bit of a hack. First, toggle the @State variable to immediately update the UI.
                // Perform the state modification, then re-update the @State variable with the source of truth
                do {
                    isOpenAtLoginEnabled.toggle()
                    
                    if SMAppService.mainApp.status == .enabled {
                        try SMAppService.mainApp.unregister()
                    } else {
                        try SMAppService.mainApp.register()
                    }
                } catch {
                    Logger.config.error("Error updating Open at Login: \(error.localizedDescription)")
                }
                isOpenAtLoginEnabled = SMAppService.mainApp.status == .enabled
            } label: {
                if isOpenAtLoginEnabled {
                    Image(systemName: "checkmark")
                }
                Text("Open at Login")
            }
            
            Button("Quit", action: spotifyViewModel.quitSoundSeer)
        } label: {
            Group {
                if spotifyViewModel.playerState != .playing || spotifyViewModel.nowPlaying.isEmpty {
                    Image(systemName: "ear")
                } else {
                    Text(spotifyViewModel.nowPlaying)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didChangeOcclusionStateNotification)) { notification in
                Logger.view.debug("Received didChangeOcclusionState notification")
                
                guard let window = notification.object as? NSWindow else { return }
                spotifyViewModel.isAppVisibleInMenuBar = window.occlusionState.contains(.visible)
            }
            .background(WindowAccessor(window: $window))
        }
    }
}
