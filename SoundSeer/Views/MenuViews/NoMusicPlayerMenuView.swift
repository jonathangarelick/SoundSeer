import SwiftUI

struct NoMusicPlayerMenuView: View {
    var viewModel: SoundSeerViewModel

    var body: some View {
        WarningView("Music player not found.")

        Divider()
        
        SettingsView(viewModel: viewModel)
    }
}
