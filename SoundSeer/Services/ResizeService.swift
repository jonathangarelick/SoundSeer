import AppKit
import Combine
import Foundation
import OSLog

class ResizeService {
    static let shared = ResizeService()

    let subject: CurrentValueSubject<Int, Never>
    private var cancellables = Set<AnyCancellable>()
    private var firstUpdate = true
    private let maxLength = 45
    private var playbackState: PlaybackState = .stopped
    private var timerCancellable: AnyCancellable?

    private init() {
        subject = CurrentValueSubject(maxLength)

        CurrentPlayerService.shared.subject
            .compactMap { $0?.playbackState }
            .assign(to: \.playbackState, on: self)
            .store(in: &cancellables)

        handleIsVisibleChanged(false)
        firstUpdate = false

        NotificationCenter.default
            .publisher(for: NSWindow.didChangeOcclusionStateNotification)
            .compactMap { $0.object as? NSWindow }
            .filter { $0.className == "NSStatusBarWindow" }
            .map { $0.occlusionState.contains(.visible) }
            .sink { [weak self] isVisible in
                Logger.view.debug("MenuBarExtra is visible: \(isVisible)")
                self?.handleIsVisibleChanged(isVisible)
            }
            .store(in: &cancellables)
    }

    func resetSubject() {
        subject.send(maxLength)
    }

    private func handleIsVisibleChanged(_ isVisible: Bool) {
        Logger.view.debug("Resizing stopped")
        timerCancellable?.cancel()

        guard !isVisible, !Utils.isAppInMenuBar(.soundSeer), (firstUpdate || playbackState == .playing) else { return }

        Logger.view.debug("Resizing started")
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] test in
                guard let self = self else { return }

                if subject.value >= 5 {
                    subject.send(subject.value - 5)
                } else {
                    Logger.view.debug("Resizing stopped")
                    timerCancellable?.cancel()
                }
            }
    }
}
