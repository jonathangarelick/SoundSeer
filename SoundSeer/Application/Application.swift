protocol Application {
    static var shared: Application { get }

    var playerState: PlayerState { get }

    func copySongURL()
    func nextTrack()
    func revealSong()
    func revealArtist()
    func revealAlbum()
}
