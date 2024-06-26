import SwiftUI

struct SongDetailsView: View {
    @ObservedObject var viewModel: SoundSeerViewModel

    var body: some View {
        Button(viewModel.songShort, systemImage: "music.note", action: viewModel.revealSong)
            .labelStyle(.titleAndIcon)
            .disabled(!viewModel.canRevealSong)

        Button(viewModel.artistShort, systemImage: "person", action: viewModel.revealArtist)
            .labelStyle(.titleAndIcon)
            .disabled(!viewModel.canRevealArtist)

        Button(viewModel.albumShort, systemImage: "opticaldisc", action: viewModel.revealAlbum)
            .labelStyle(.titleAndIcon)
            .disabled(!viewModel.canRevealAlbum)
    }
}
