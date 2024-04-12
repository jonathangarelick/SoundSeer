//
//  SpotifyController.swift
//  SoundSeer
//
//  Created by Jonathan Garelick on 4/12/24.
//

import Foundation

class SpotifyController {
    func getCurrentSong() -> String? {
        let script = """
        tell application "Spotify"
            if it is running then
                set currentTrack to name of current track
                set currentArtist to artist of current track
                return currentTrack & " - " & currentArtist
            else
                return "Not playing"
            end if
        end tell
        """

        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let output = appleScript?.executeAndReturnError(&error).stringValue

        if let error = error {
            print("AppleScript error: \(error)")
            return nil
        }

        return output
    }
}
