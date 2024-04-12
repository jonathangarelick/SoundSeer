//
//  SpotifyModel.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import Foundation

class SpotifyModel: ObservableObject {
    @Published var currentSong: String = ""
    var timer: Timer?

    init() {
        print("in init")
    }

    func startUpdating() {
        print("hello update")
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.updateCurrentSong()
        }
    }

    func stopUpdating() {
        timer?.invalidate()
        timer = nil
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
                self.currentSong = "Error retrieving song"
            } else {
                self.currentSong = output ?? "Not playing"
            }
        }
    }
}
