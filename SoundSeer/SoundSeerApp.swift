import SwiftUI
import AppKit

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyViewModel = SpotifyViewModel()

    var body: some Scene {
        MenuBarExtra {
            Button("Next track", systemImage: "forward.end") {
                SpotifyAPI.skipToNextTrack()
            }.labelStyle(.titleAndIcon)

            Divider()

            Button(!spotifyViewModel.currentSong.isEmpty ? spotifyViewModel.currentSong : "Song unknown", systemImage: "music.note") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .song) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)


            Button(!spotifyViewModel.currentArtist.isEmpty ? spotifyViewModel.currentArtist : "Artist unknown", systemImage: "person") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .artist) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)
            Button(!spotifyViewModel.currentAlbum.isEmpty ? spotifyViewModel.currentAlbum : "Album unknown", systemImage: "opticaldisc") {
                SpotifyAPI.getSpotifyURI(from: spotifyViewModel.currentSongId, type: .album) { uri in
                    if let uriString = uri, let url = URL(string: uriString) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
            .labelStyle(.titleAndIcon)

            Divider()

            Button("Copy Spotify URL", systemImage: "doc.on.doc") {
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([.string], owner: nil)
                pasteboard.setString("https://open.spotify.com/track/\(spotifyViewModel.currentSongId)", forType: .string)
            }.labelStyle(.titleAndIcon)

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            if spotifyViewModel.nowPlaying.isEmpty {
                Image(systemName: "ear.badge.waveform")
            } else {
                Text(spotifyViewModel.nowPlaying)
            }
        }

    }
}
