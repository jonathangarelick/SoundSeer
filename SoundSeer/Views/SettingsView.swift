import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
    var viewModel: SoundSeerViewModel

    var body: some View {
        Menu("Settings") {
            LaunchAtLogin.Toggle("Open at Login")
            Button("Reset Width", action: viewModel.resetWidth)
        }

        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
