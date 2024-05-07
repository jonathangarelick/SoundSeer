import SwiftUI

struct PlayerControlsView: View {
    @ObservedObject var viewModel: SoundSeerViewModel

    var body: some View {
        Button("Next Track", systemImage: "forward.end", action: viewModel.nextTrack)
            .labelStyle(.titleAndIcon)
            .disabled(viewModel.isPlayerStopped)
    }
}
