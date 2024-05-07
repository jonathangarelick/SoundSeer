import OSLog
import SwiftUI

enum AppState {
    case ok
    case noMusicPlayer
    case outOfSpace
}

@main
struct SoundSeerApp: App {
    @StateObject var viewModel = SoundSeerViewModel()

    var state: AppState {
        if !viewModel.isValid {
            return .noMusicPlayer
        } else if viewModel.isPlaying, viewModel.prefixLength <= 0 {
            return .outOfSpace
        } else {
            return .ok
        }
    }

    var body: some Scene {
        MenuBarExtra {
            switch state {
            case .noMusicPlayer:
                WarningView("Music player not found.")

            case .outOfSpace:
                WarningView("Not enough room for song. Try restarting.")

            case .ok:
                PlayerControlsView(viewModel: viewModel)
                Divider()
                SongDetailsView(viewModel: viewModel)
                Divider()
                Button("Copy Song URL", systemImage: "doc.on.doc", action: viewModel.copySongExternalURL)
                    .labelStyle(.titleAndIcon)
                    .disabled(viewModel.currentSongId.isEmpty)
            }

            Divider()
            SettingsView()
        } label: {
            switch state {
            case .ok:
                NowPlayingView(viewModel: viewModel)
            default:
                Image(systemName: "ear")
            }
        }
    }
}
