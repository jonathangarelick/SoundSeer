protocol Application {
    static var shared: Application { get }

    func copySongURL()
    func nextTrack()
    func revealSong()
    func revealArtist()
    func revealAlbum()
}
