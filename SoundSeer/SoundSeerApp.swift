//
//  SoundSeerApp.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import SwiftUI

@main
struct SoundSeerApp: App {
    @StateObject private var timerModel = TimerModel()
    @State private var isMenuBarExtraVisible = true

    var body: some Scene {
        MenuBarExtra {
            MenuBarView(timerModel: timerModel)
        } label: {
            Text("\(timerModel.count)")
                .font(.system(size: 12))
        }
        .menuBarExtraStyle(.window)
    }
}

// https://sarunw.com/posts/swiftui-menu-bar-app
// https://blog.schurigeln.com/menu-bar-apps-swift-ui/
//
