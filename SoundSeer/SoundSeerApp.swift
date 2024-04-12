//
//  SoundSeerApp.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject private var spotifyModel = SpotifyModel()

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(spotifyModel: spotifyModel)

        } label: {



//            Text("Everyday (feat. Rod Stewart, Mig")
            GeometryReader{g in
                ZStack {
                    Circle().strokeBorder(Color.red, lineWidth: 30)
                    Text("Everyday (feat. Rod Stewart, Migsdafadfadfdsfsdfadfs")
                        .font(.system(size: g.size.height > g.size.width ? g.size.width * 0.4: g.size.height * 0.4))
                }
            }


//            Text(String("Everyday (feat. Rod Stewart, Miguel & Mark Ronso".prefix(20)))
//                .lineLimit(1)
//                .truncationMode(.middle)
//                .fixedSize(horizontal: true, vertical: false)
//                .frame(width: 150)
//            //            Text(spotifyModel.currentSong)
//                .onAppear {
//                    spotifyModel.startUpdating()
//                }
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
