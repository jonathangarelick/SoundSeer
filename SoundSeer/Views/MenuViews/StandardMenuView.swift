import SwiftUI

struct StandardMenuView: View {
    var viewModel: SoundSeerViewModel

    var body: some View {
        PlayerControlsView(viewModel: viewModel)

        Divider()

        SongDetailsView(viewModel: viewModel)

        Divider()

        SettingsView(viewModel: viewModel)
    }
}
