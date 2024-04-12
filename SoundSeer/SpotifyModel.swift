//
//  SpotifyModel.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import Foundation

class SpotifyModel: ObservableObject {
    @Published var currentSong: String = ""
    var currentSongRaw: String = "aaa"

    var spotifyTimer: Timer?
    var marqueeTimer: Timer?

    var marqueeLen = 30


    var startIdx = -1
    var endIdx = 9

    func startUpdating() {
        print("Hello")

//        spotifyTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
//            self.updateCurrentSong()
//        }

        let endIndex = currentSongRaw.index(currentSongRaw.startIndex, offsetBy: min(currentSongRaw.count, marqueeLen)) // Index 5 (after "Hello")
        let substring = currentSongRaw[currentSongRaw.startIndex..<endIndex] // "Hello"
//        currentSong = currentSongRaw[String.before(String.index(min(endIdx, currentSongRaw.count)))]
        print(currentSong)

        spotifyTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            self.updateMarquee()
        }
    }

    func stopUpdating() {
        spotifyTimer?.invalidate()
        spotifyTimer = nil
    }

    func updateMarquee() {
        startIdx = (startIdx + 1) % min(marqueeLen, currentSongRaw.count)
        endIdx = (endIdx + 1) % min(marqueeLen, currentSongRaw.count)

        if !currentSong.isEmpty {
            currentSong.removeFirst()
            currentSong.append(currentSongRaw[endIdx])
        }
    }

    func updateCurrentSong() {
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

        if var output = output {
            output = String(output.prefix(10))
        }

        print(output)

        DispatchQueue.main.async {
            if let error = error {
                print("AppleScript error: \(error)")
                self.currentSongRaw = "Error retrieving song"
            } else {
                self.currentSongRaw = output ?? "Not playing"
            }
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
