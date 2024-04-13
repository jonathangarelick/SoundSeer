import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyViewModel = SpotifyViewModel()

    var body: some Scene {
        MenuBarExtra {
            Button(spotifyViewModel.currentArtist, systemImage: "person") {}
                .labelStyle(.titleAndIcon)
            Button(spotifyViewModel.currentAlbum, systemImage: "opticaldisc") {}
                .labelStyle(.titleAndIcon)

            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            Image(systemName: "ear.badge.waveform")
            Text(spotifyViewModel.currentSong)
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
// Concurrency: https://developer.apple.com/library/archive/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html#//apple_ref/doc/uid/TP40008091-CH102-SW1

