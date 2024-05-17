import SwiftUI

struct WarningView: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Button(title, systemImage: "exclamationmark.triangle", action: {})
            .labelStyle(.titleAndIcon)
            .disabled(true)
    }
}

