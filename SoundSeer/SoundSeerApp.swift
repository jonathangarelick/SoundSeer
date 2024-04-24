import OSLog
import ServiceManagement
import SwiftUI

@main
struct SoundSeerApp: App {
    // https://swiftwithmajid.com/2022/04/06/logging-in-swift/
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: SoundSeerApp.self)
    )

    @StateObject private var spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    @State private var window: NSWindow?
    @State private var isOpenAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled

    var body: some Scene {
        MenuBarExtra {
            Button("Next Track", systemImage: "forward.end", action: spotifyViewModel.nextTrack)
                .labelStyle(.titleAndIcon)
                .disabled(spotifyViewModel.playerState != .paused && spotifyViewModel.playerState != .playing)

            Divider()

            Button(!spotifyViewModel.currentSong.isEmpty ? spotifyViewModel.currentSong : "Song unknown", systemImage: "music.note", action: spotifyViewModel.openCurrentSong)
                .labelStyle(.titleAndIcon)
                .disabled(spotifyViewModel.currentSongId.isEmpty)

            Button(!spotifyViewModel.currentArtist.isEmpty ? spotifyViewModel.currentArtist : "Artist unknown", systemImage: "person", action: spotifyViewModel.openCurrentArtist)
                .labelStyle(.titleAndIcon)
                .disabled(spotifyViewModel.currentSongId.isEmpty)

            Button(!spotifyViewModel.currentAlbum.isEmpty ? spotifyViewModel.currentAlbum : "Album unknown", systemImage: "opticaldisc", action: spotifyViewModel.openCurrentAlbum)
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
                    Self.logger.error("Error updating Open at Login: \(error.localizedDescription)")
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
                guard let window = notification.object as? NSWindow else { return }

                spotifyViewModel.isVisible = window.occlusionState.contains(.visible)
                print("isVisible: ", spotifyViewModel.isVisible)
            }
            .background(WindowAccessor(window: $window))
        }

    }
}
