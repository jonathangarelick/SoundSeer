import Foundation

class SpotifyModel: ObservableObject {
    @Published var currentSongDisplay: String = "🤫"
    var currentSong: String = ""

    var spotifyTimer: Timer?
    var marqueeTimer: Timer?

    var marqueeLen = 30

    var endIdx = 30

    func startUpdating() {
        spotifyTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.getCurrentSong()

            if !self.currentSong.isEmpty && self.marqueeTimer == nil {
                print("currentSongRaw is", self.currentSong)
                self.startMarqueeTimer()
            }
        }
    }

    func startMarqueeTimer() {
        marqueeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            self.updateMarquee()
        }
    }

    func stopUpdating() {
        spotifyTimer?.invalidate()
        spotifyTimer = nil
    }

    func updateMarquee() {
        if currentSongDisplay == "🤫" {
            return
        } else {
            currentSongDisplay.removeFirst()
            currentSongDisplay.append(currentSong[endIdx % currentSong.count])
            endIdx += 1
        }
    }

    func getCurrentSong() {
        let script = """
        tell application "Spotify"
            if it is running then
                set currentTrack to name of current track
                set currentArtist to artist of current track
                return currentTrack & " - " & currentArtist
            else
                return "Spotify is not running"
            end if
        end tell
        """

        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        var output = appleScript?.executeAndReturnError(&error).stringValue

        DispatchQueue.main.async { [self] in
            if let error = error {
                print("AppleScript error: \(error)")
                self.currentSong = "Error retrieving song"
            } else if let output = output {

            }
    }
}

extension StringProtocol {
    subscript(_ offset: Int)                     -> Element     { self[index(startIndex, offsetBy: offset)] }
    subscript(_ range: Range<Int>)               -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: ClosedRange<Int>)         -> SubSequence { prefix(range.lowerBound+range.count).suffix(range.count) }
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence { prefix(range.upperBound.advanced(by: 1)) }
    subscript(_ range: PartialRangeUpTo<Int>)    -> SubSequence { prefix(range.upperBound) }
    subscript(_ range: PartialRangeFrom<Int>)    -> SubSequence { suffix(Swift.max(0, count-range.lowerBound)) }
}
