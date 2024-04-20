import SwiftUI

import LaunchAtLogin

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyViewModel: SpotifyViewModel = SpotifyViewModel()
    @State private var window: NSWindow?

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

            Button(action: spotifyViewModel.toggleOpenAtLogin) {
                if LaunchAtLogin.isEnabled {
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
