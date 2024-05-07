import OSLog
import ServiceManagement
import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject var viewModel = SoundSeerViewModel()
    @State var isOpenAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled
    
    private struct LabelContent: View {
        @ObservedObject var playerViewModel: SoundSeerViewModel
        @State private var window: NSWindow?
        
        var body: some View {
            Group {
                if playerViewModel.playerState?.playbackState != .playing || playerViewModel.nowPlaying.isEmpty {
                    Image(systemName: "ear")
                } else {
                    Text(playerViewModel.nowPlaying)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: NSWindow.didChangeOcclusionStateNotification)) { notification in
                Logger.view.debug("Received didChangeOcclusionState notification")
                
                guard let window = notification.object as? NSWindow else { return }
                playerViewModel.isAppVisibleInMenuBar = window.occlusionState.contains(.visible)
            }
            .background(WindowAccessor(window: $window))
        }
    }
    
    var body: some Scene {
        MenuBarExtra {
            if viewModel.model != nil {
                if viewModel.playerState?.playbackState == .playing, viewModel.prefixLength <= 0 {
                    Button("Not enough room for song. Try restarting.", systemImage: "exclamationmark.triangle", action: {})
                        .labelStyle(.titleAndIcon)
                        .disabled(true)
                }
                
                Button("Next Track", systemImage: "forward.end", action: viewModel.nextTrack)
                    .labelStyle(.titleAndIcon)
                    .disabled(viewModel.playerState?.playbackState != .paused && viewModel.playerState?.playbackState != .playing)
                
                Divider()
                
                Button(!viewModel.currentSong.isEmpty
                       ? (viewModel.prefixLength > 0
                          ? viewModel.currentSong.truncate(length: Int(Double(viewModel.prefixLength) * 1.5))
                          : viewModel.currentSong.truncate(length: 60))
                       : "Song unknown", systemImage: "music.note", action: viewModel.openCurrentSong)
                .labelStyle(.titleAndIcon)
                .disabled(viewModel.currentSongId.isEmpty)
                
                Button(!viewModel.currentArtist.isEmpty
                       ? (viewModel.prefixLength > 0
                          ? viewModel.currentArtist.truncate(length: Int(Double(viewModel.prefixLength) * 1.5))
                          : viewModel.currentArtist.truncate(length: 60))
                       : "Artist unknown", systemImage: "person", action: viewModel.openCurrentArtist)
                .labelStyle(.titleAndIcon)
                .disabled(viewModel.currentSongId.isEmpty)
                
                Button(!viewModel.currentAlbum.isEmpty
                       ? (viewModel.prefixLength > 0
                          ? viewModel.currentAlbum.truncate(length: Int(Double(viewModel.prefixLength) * 1.5))
                          : viewModel.currentAlbum.truncate(length: 60))
                       : "Album unknown", systemImage: "opticaldisc", action: viewModel.openCurrentAlbum)
                .labelStyle(.titleAndIcon)
                .disabled(viewModel.currentSongId.isEmpty)
                
                Divider()
                
                Button("Copy Song URL", systemImage: "doc.on.doc", action: viewModel.copySongExternalURL)
                    .labelStyle(.titleAndIcon)
                    .disabled(viewModel.currentSongId.isEmpty)
            } else {
                Button("Spotify app not found.", systemImage: "exclamationmark.triangle", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            }
            
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
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            if viewModel.model != nil {
                LabelContent(playerViewModel: viewModel)
            } else {
                Image(systemName: "ear")
            }
        }
    }
}
