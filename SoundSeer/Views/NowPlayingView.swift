import SwiftUI

struct NowPlayingView: View {
    var viewModel: SoundSeerViewModel

    var body: some View {
        if viewModel.isPlaying, !viewModel.nowPlaying.isEmpty {
            Text(viewModel.nowPlaying)
        } else {
            Image(systemName: "ear")
        }
    }
}
