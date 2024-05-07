import OSLog
import SwiftUI

struct NowPlayingView: View {
    @State var window: NSWindow?
    @ObservedObject var viewModel: SoundSeerViewModel

    var body: some View {
        Group {
            if !viewModel.isPlaying || viewModel.nowPlaying.isEmpty {
                Image(systemName: "ear")
            } else {
                Text(viewModel.nowPlaying)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.didChangeOcclusionStateNotification)) { notification in
            Logger.view.debug("Received didChangeOcclusionState notification")

            guard let window = notification.object as? NSWindow else { return }
            viewModel.isAppVisibleInMenuBar = window.occlusionState.contains(.visible)
        }
        .background(WindowAccessor(window: $window))
    }

    // https://stackoverflow.com/a/63439982
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
}
