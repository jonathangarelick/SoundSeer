import SwiftUI

struct SongDetailsView: View {
    @ObservedObject var viewModel: SoundSeerViewModel

    var body: some View {
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
    }
}
