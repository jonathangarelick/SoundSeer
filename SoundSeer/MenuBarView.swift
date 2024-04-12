//
//  MenuBarView.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import SwiftUI

struct MenuBarView: View {

    @ObservedObject var timerModel: TimerModel

        var body: some View {
            VStack {
                Button("Start") {
                    timerModel.startTimer()
                }

                Button("Stop") {
                    timerModel.stopTimer()
                }

                Divider()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .foregroundColor(.red)
            }
            .padding(4)
        }
}
