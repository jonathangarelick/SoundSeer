import OSLog
import ServiceManagement
import SwiftUI

struct SettingsView: View {
    @State var isOpenAtLoginEnabled: Bool = SMAppService.mainApp.status == .enabled

    var body: some View {
        Button {
            // This is a bit of a hack. First, toggle the @State variable to immediately update the UI.
            // Perform the state modification, then re-update the @State variable with the source of truth
            do {
                isOpenAtLoginEnabled.toggle()

                if SMAppService.mainApp.status == .enabled {
                    try SMAppService.mainApp.unregister()
                } else {
                    try SMAppService.mainApp.register()
                }
            } catch {
                Logger.config.error("Error updating Open at Login: \(error.localizedDescription)")
            }
            isOpenAtLoginEnabled = SMAppService.mainApp.status == .enabled
        } label: {
            if isOpenAtLoginEnabled {
                Image(systemName: "checkmark")
            }
            Text("Open at Login")
        }
        
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
    }
}
