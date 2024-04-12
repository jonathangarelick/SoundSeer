//
//  TimerModel.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import Foundation

class TimerModel: ObservableObject {
    @Published var count: Int = 0
    var timer: Timer?

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.count += 1
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
