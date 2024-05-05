import Foundation
import OSLog
import Alamofire

class MusicAPI {
    static let baseURL = "https://api.music.apple.com/v1"
    static let developerToken = "your_developer_token"

    static func getMusicURI(from songID: String, type: MusicURIType, completion: @escaping (String?) -> Void) {
        switch type {
        case .song:
            let url = "\(baseURL)/catalog/us/songs/\(songID)"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(developerToken)",
                "Music-User-Token": developerToken
            ]

            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: SongResponse.self) { response in
                    switch response.result {
                    case .success(let songResponse):
                        completion(songResponse.data.first?.attributes?.url)
                    case .failure(let error):
                        Logger.api.error("Error getting song URI: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        case .artist, .album:
            getArtistOrAlbumID(from: songID, type: type == .artist ? MusicIDType.artist : MusicIDType.album) { id in
                guard let id = id else {
                    completion(nil)
                    return
                }

                let url: String
                switch type {
                case .artist:
                    url = "\(baseURL)/catalog/us/artists/\(id)"
                case .album:
                    url = "\(baseURL)/catalog/us/albums/\(id)"
                case .song:
                    // This case is handled separately
                    return
                }

                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(developerToken)",
                    "Music-User-Token": developerToken
                ]

                AF.request(url, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: URIResponse.self) { response in
                        switch response.result {
                        case .success(let uriResponse):
                            completion(uriResponse.uri)
                        case .failure(let error):
                            Logger.api.error("Error getting URI: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
            }
        }
    }

    static func getArtistOrAlbumID(from songID: String, type: MusicIDType, completion: @escaping (String?) -> Void) {
        let url = "\(baseURL)/catalog/us/songs/\(songID)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(developerToken)",
            "Music-User-Token": developerToken
        ]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: SongResponse.self) { response in
                switch response.result {
                case .success(let songResponse):
                    switch type {
                    case .artist:
                        if let artistID = songResponse.data.first?.relationships?.artists?.data.first?.id {
                            completion(artistID)
                        } else {
                            completion(nil)
                        }
                    case .album:
                        if let albumID = songResponse.data.first?.relationships?.albums?.data.first?.id {
                            completion(albumID)
                        } else {
                            completion(nil)
                        }
                    }
                case .failure(let error):
                    Logger.api.error("Error getting artist or album ID: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
}

enum MusicIDType {
    case artist, album
}

struct SongResponse: Decodable {
    let data: [Song]
}

struct Song: Decodable {
    let id: String
    let attributes: SongAttributes?
    let relationships: SongRelationships?
}

struct SongAttributes: Decodable {
    let url: String
}

struct SongRelationships: Decodable {
    let artists: MusicArtists?
    let albums: MusicAlbums?
}

struct MusicArtists: Decodable {
    let data: [MusicArtist]
}

struct MusicArtist: Decodable {
    let id: String
}

struct MusicAlbums: Decodable {
    let data: [MusicAlbum]
}

struct MusicAlbum: Decodable {
    let id: String
}

enum MusicURIType {
    case song, artist, album
}

struct MusicURIResponse: Decodable {
    let uri: String
}
