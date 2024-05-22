import AppKit
import Combine
import Foundation

class ResizeService {
    static let shared = ResizeService()

    let subject: CurrentValueSubject<Int, Never>
    private var cancellables = Set<AnyCancellable>()
    private var firstUpdate = true
    private let maxLength = 100
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
            .sink { [weak self] in
                self?.handleIsVisibleChanged($0)
            }
            .store(in: &cancellables)
    }

    private func handleIsVisibleChanged(_ isVisible: Bool) {
        timerCancellable?.cancel()

        guard !isVisible, !Utils.isAppInMenuBar(.soundSeer), (firstUpdate || playbackState == .playing) else { return }

        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] test in
                guard let self = self else { return }

                if subject.value >= 5 {
                    subject.send(subject.value - 5)
                } else {
                    timerCancellable?.cancel()
                }
            }
    }
}
