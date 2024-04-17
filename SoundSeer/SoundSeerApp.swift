import SwiftUI

import LaunchAtLogin

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyViewModel = SpotifyViewModel()

    var body: some Scene {
        MenuBarExtra {
            Button("Next Track", systemImage: "forward.end") {
                SpotifyAPI.skipToNextTrack()
            }
            .labelStyle(.titleAndIcon)
            .disabled(!spotifyViewModel.isApplicationRunning)

            Divider()

            Button(!spotifyViewModel.currentSong.isEmpty ? spotifyViewModel.currentSong : "Song unknown", systemImage: "music.note") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .song) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)

            Button(!spotifyViewModel.currentArtist.isEmpty ? spotifyViewModel.currentArtist : "Artist unknown", systemImage: "person") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .artist) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)

            Button(!spotifyViewModel.currentAlbum.isEmpty ? spotifyViewModel.currentAlbum : "Album unknown", systemImage: "opticaldisc") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .album) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)

            Divider()

            Button("Copy Spotify URL", systemImage: "doc.on.doc") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString("https://open.spotify.com/track/\(spotifyViewModel.currentSongId)", forType: .string)
            }
            .labelStyle(.titleAndIcon)
            .disabled(spotifyViewModel.currentSongId.isEmpty)

            Divider()

            Button {
                LaunchAtLogin.isEnabled.toggle()
            } label: {
                if LaunchAtLogin.isEnabled {
                    Image(systemName: "checkmark")
                }
                Text("Open at Login")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            if spotifyViewModel.playerState != PlayerState.playing || spotifyViewModel.nowPlaying.isEmpty {
                Image(systemName: "ear")
            } else {
                Text(spotifyViewModel.nowPlaying)
            }
        }
    }
}
