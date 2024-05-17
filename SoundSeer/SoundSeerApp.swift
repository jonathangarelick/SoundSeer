import SwiftUI

@main
struct SoundSeerApp: App {
    @State private var viewModel = SoundSeerViewModel()

    var body: some Scene {
        MenuBarExtra {
            if viewModel.hasNoMusicPlayer {
                NoMusicPlayerMenuView(viewModel: viewModel)
            } else if viewModel.isOutOfSpace {
                OutOfSpaceMenuView(viewModel: viewModel)
            } else {
                StandardMenuView(viewModel: viewModel)
            }
        } label: {
            NowPlayingView(viewModel: viewModel)
        }
    }
}
