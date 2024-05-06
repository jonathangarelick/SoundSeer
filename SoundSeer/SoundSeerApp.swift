import OSLog
import ServiceManagement
import SwiftUI

@main
struct SoundSeerApp: App {
    @State private var isOpenAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled

    private var playerViewModel: PlayerViewModel? = PlayerViewModel()

    // https://stackoverflow.com/a/67065308
    private struct SongMetaContent: View {
        @ObservedObject var playerViewModel: PlayerViewModel

        var body: some View {
            if playerViewModel.playerState == .playing, playerViewModel.prefixLength <= 0 {
                Button("Not enough room for song. Try restarting.", systemImage: "exclamationmark.triangle", action: {})
                    .labelStyle(.titleAndIcon)
                    .disabled(true)
            }

            Button("Next Track", systemImage: "forward.end", action: playerViewModel.nextTrack)
                .labelStyle(.titleAndIcon)
                .disabled(playerViewModel.playerState != .paused && playerViewModel.playerState != .playing)

            Divider()

            Button(!playerViewModel.currentSong.isEmpty
                   ? (playerViewModel.prefixLength > 0
                      ? playerViewModel.currentSong.truncate(length: Int(Double(playerViewModel.prefixLength) * 1.5))
                      : playerViewModel.currentSong.truncate(length: 60))
                   : "Song unknown", systemImage: "music.note", action: playerViewModel.openCurrentSong)
            .labelStyle(.titleAndIcon)
            .disabled(playerViewModel.currentSongId.isEmpty)

            Button(!playerViewModel.currentArtist.isEmpty
                   ? (playerViewModel.prefixLength > 0
                      ? playerViewModel.currentArtist.truncate(length: Int(Double(playerViewModel.prefixLength) * 1.5))
                      : playerViewModel.currentArtist.truncate(length: 60))
                   : "Artist unknown", systemImage: "person", action: playerViewModel.openCurrentArtist)
            .labelStyle(.titleAndIcon)
            .disabled(playerViewModel.currentSongId.isEmpty)

            Button(!playerViewModel.currentAlbum.isEmpty
                   ? (playerViewModel.prefixLength > 0
                      ? playerViewModel.currentAlbum.truncate(length: Int(Double(playerViewModel.prefixLength) * 1.5))
                      : playerViewModel.currentAlbum.truncate(length: 60))
                   : "Album unknown", systemImage: "opticaldisc", action: playerViewModel.openCurrentAlbum)
            .labelStyle(.titleAndIcon)
            .disabled(playerViewModel.currentSongId.isEmpty)

            Divider()

            Button("Copy Song URL", systemImage: "doc.on.doc", action: playerViewModel.copySongExternalURL)
                .labelStyle(.titleAndIcon)
                .disabled(playerViewModel.currentSongId.isEmpty)
        }
    }

    private struct LabelContent: View {
        @ObservedObject var playerViewModel: PlayerViewModel
        @State private var window: NSWindow?

        var body: some View {
            Group {
                if playerViewModel.playerState != .playing || playerViewModel.nowPlaying.isEmpty {
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
            if let playerViewModel = playerViewModel {
                SongMetaContent(playerViewModel: playerViewModel)
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
            if let playerViewModel = playerViewModel {
                LabelContent(playerViewModel: playerViewModel)
            } else {
                Image(systemName: "ear")
            }
        }
    }
}
