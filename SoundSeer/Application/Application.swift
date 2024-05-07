enum ApplicationType {
    case music, spotify
}

protocol Application {
    static var shared: Application { get }

    static func copySongURL()
    static func nextTrack()
    static func revealSong()
    static func revealArtist()
    static func revealAlbum()
}
