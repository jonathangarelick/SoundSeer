enum Player: String {
    case music = "com.apple.music"
    case spotify = "com.spotify.client"

    var bundleID: String {
        return self.rawValue
    }

    var API: PlayerAPI.Type {
        switch self {
        case .music:
            return MusicAPI.self
        case .spotify:
            return SpotifyAPI.self
        }
    }

    var baseSongURL: String {
        switch self {
        case .music:
         return "https://music.apple.com/album"
        case .spotify:
            return "https://open.spotify.com/track"
        }
    }
}
