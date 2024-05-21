import AppKit
import Combine
import Foundation

class ResizeService {
    static let shared = ResizeService()

    private static let maxLength = 100

    var currentLengthSubject = PassthroughSubject<Int, Never>()
    private var currentLength = maxLength {
        didSet {
            currentLengthSubject.send(currentLength)
        }
    }
    private var playbackState: PlaybackState?
    private var timer: Timer?

    private init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.handleOcclusionStateChanged(false)
            self?.addObservers()
        }
    }

    deinit {
        removeObservers()
        timer?.invalidate()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .ssOcclusionStateChanged, object: nil, queue: nil) { [weak self] in
            print("occlusion state changed")
            guard let isVisible = ($0.userInfo?["occlusionState"] as? NSWindow.OcclusionState)?.contains(.visible) else { return }
            print(isVisible)
            self?.handleOcclusionStateChanged(isVisible)
        }

        NotificationCenter.default.addObserver(forName: .ssPlaybackStateChanged, object: nil, queue: nil) { [weak self] in
            guard let playbackState = $0.userInfo?["playbackState"] as? PlaybackState else { return }
            self?.playbackState = playbackState
        }
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

    private func handleOcclusionStateChanged(_ isVisible: Bool) {
        timer?.invalidate()

        guard !isVisible, !isAppInMenuBar("SoundSeer"), playbackState == .playing else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            if currentLength >= 5 {
                currentLength -= 5
            } else {
                timer.invalidate()
            }
        }
    }


    // https://stackoverflow.com/a/77304045
    private func isAppInMenuBar(_ appName: String) -> Bool {
        let processNamesWithStatusItems = Set(
            (CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as! [NSDictionary])
                .filter { $0[kCGWindowLayer] as! Int == 25 }
                .map { $0[kCGWindowOwnerName] as! String }
        )

        return processNamesWithStatusItems.contains(appName)
    }
}
