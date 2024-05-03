enum Player: String {
    case music = "com.apple.music"
    case spotify = "com.spotify.client"

    var bundleID: String {
        return self.rawValue
    }
}
