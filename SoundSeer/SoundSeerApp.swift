import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyManager = SpotifyManager()

    var body: some Scene {
        MenuBarExtra {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Text(spotifyManager.currentSong)
        }
    }
}

// text stop display at "Everyday (feat. Rod Stewart, Miguel & Mark Ronso" (that's 48 chars)
// https://sarunw.com/posts/swiftui-menu-bar-app
// https://blog.schurigeln.com/menu-bar-apps-swift-ui/
// tccutil reset AppleEvents net.garelick.SoundSeer
// https://joshspicer.com/applescript
// https://stackoverflow.com/questions/77131963/how-to-identify-if-the-menubarextra-in-macos-is-hidden-by-the-system
// https://github.com/kmikiy/SpotMenu/issues/141
