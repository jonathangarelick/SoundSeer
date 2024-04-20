import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window   // << right after inserted in window
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct MenuBarExtraLabelView: View {
    @ObservedObject var spotifyViewModel: SpotifyViewModel
    @State private var window: NSWindow?

    var body: some View {
        Group {
            if spotifyViewModel.playerState != .playing || spotifyViewModel.nowPlaying.isEmpty {
                Image(systemName: "ear")
            } else {
                Text(spotifyViewModel.nowPlaying)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didChangeOcclusionStateNotification)) { notification in
            guard let window = notification.object as? NSWindow else {
                return
            }
            
            spotifyViewModel.isVisible = window.occlusionState.contains(.visible)
//            print("MenuBarExtraLabel is visible: \(spotifyViewModel.isVisible)")
        }
        .background(WindowAccessor(window: $window))
    }
}
