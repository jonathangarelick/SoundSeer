//
//  MenuBarView.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var spotifyModel: SpotifyModel

    var body: some View {
        VStack {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .foregroundColor(.red)
        }
        .padding(4)
    }
}
