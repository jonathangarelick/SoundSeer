import Foundation
import OSLog
import Alamofire
import SwiftJWT

class MusicAPI {
    static let baseURL = "https://api.music.apple.com/v1"
    static let secret = """
    -----BEGIN PRIVATE KEY-----
    top secret
    -----END PRIVATE KEY-----
    """
    static let keyId = "key"
    static let teamId = "team"
    static let alg = "ES256"

    static var authToken: String?
    static var authTokenExpiration: Date?

    static func generateAuthToken() -> String? {
        if let token = authToken, let expiration = authTokenExpiration, expiration > Date() {
            // Previous auth token is still valid, return it
            return token
        }

        let timeNow = Date()
        let timeExpired = timeNow.addingTimeInterval(12 * 60 * 60) // 12 hours from now

        let header = SwiftJWT.Header(kid: keyId)
        let claims = ClaimsStandardJWT(iss: teamId, exp: timeExpired, iat: timeNow)

        var jwt = JWT(header: header, claims: claims)

        do {

            let privateKey = JWTSigner.es256(privateKey: secret.data(using: .utf8)!)
            let signedJWT = try jwt.sign(using: privateKey)
            return signedJWT
        } catch {
            Logger.api.error("Error generating auth token: \(error.localizedDescription)")
            return nil
        }
    }

    static func getMusicURI(from songID: String, type: URIType, completion: @escaping (String?) -> Void) {
        guard let authToken = generateAuthToken() else {
            completion(nil)
            return
        }

        switch type {
        case .song:
            let url = "\(baseURL)/catalog/us/songs/\(songID)"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(authToken)"
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
            getArtistOrAlbumID(from: songID, type: type == .artist ? IDType.artist : IDType.album) { id in
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
                    "Authorization": "Bearer \(authToken)"
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

    static func getArtistOrAlbumID(from songID: String, type: IDType, completion: @escaping (String?) -> Void) {
        guard let authToken = generateAuthToken() else {
            completion(nil)
            return
        }

        let url = "\(baseURL)/catalog/us/songs/\(songID)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)"
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

struct Header: Codable {
    var alg: String = "ES256"
    let kid: String
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

struct MusicURIResponse: Decodable {
    let uri: String
}
