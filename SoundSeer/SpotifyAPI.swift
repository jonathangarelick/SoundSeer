import Foundation
import OSLog

import Alamofire

class SpotifyAPI {
    static let baseURL = "https://api.spotify.com/v1"
    static let clientID = "d5efe83ecf0043388152717eb2463a1e"
    static let clientSecret: String? = ProcessInfo.processInfo.environment["CLIENT_SECRET"]

    static var accessToken: String?
    static var expirationTime: Date?
    
    static func getAccessToken(completion: @escaping (String?) -> Void) {
        if let token = accessToken, let expiration = expirationTime, expiration > Date() {
            // Token is still valid, use the cached token
            completion(token)
        } else {
            // Token has expired or is not available, request a new token
            let url = "https://accounts.spotify.com/api/token"
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            guard let clientSecret = clientSecret else {
                Logger.api.error("Client secret is missing")
                completion(nil)
                return
            }
            
            let parameters: Parameters = [
                "grant_type": "client_credentials",
                "client_id": clientID,
                "client_secret": clientSecret
            ]
            
            AF.request(url, method: .post, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: AccessTokenResponse.self) { response in
                    switch response.result {
                    case .success(let tokenResponse):
                        accessToken = tokenResponse.accessToken
                        expirationTime = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
                        completion(accessToken)
                    case .failure(let error):
                        Logger.api.error("Error getting access token: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    }
    
    static func getSpotifyURI(from songID: String, type: URIType, completion: @escaping (String?) -> Void) {
        switch type {
        case .song:
            getAccessToken { token in
                guard let accessToken = token else {
                    completion(nil)
                    return
                }
                
                let url = "\(baseURL)/tracks/\(songID)"
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)"
                ]
                
                AF.request(url, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: URIResponse.self) { response in
                        switch response.result {
                        case .success(let uriResponse):
                            completion(uriResponse.uri)
                        case .failure(let error):
                            Logger.api.error("Error getting song URI: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
            }
        case .artist, .album:
            getArtistOrAlbumID(from: songID, type: type == .artist ? IDType.artist : IDType.album) { id in
                guard let id = id else {
                    completion(nil)
                    return
                }
                
                getAccessToken { token in
                    guard let accessToken = token else {
                        completion(nil)
                        return
                    }
                    
                    let url: String
                    switch type {
                    case .artist:
                        url = "\(baseURL)/artists/\(id)"
                    case .album:
                        url = "\(baseURL)/albums/\(id)"
                    case .song:
                        // This case is handled separately
                        return
                    }
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer \(accessToken)"
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
    }
    
    static func getArtistOrAlbumID(from songID: String, type: IDType, completion: @escaping (String?) -> Void) {
        getAccessToken { token in
            guard let accessToken = token else {
                completion(nil)
                return
            }
            
            let url = "\(baseURL)/tracks/\(songID)"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(accessToken)"
            ]
            
            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: TrackResponse.self) { response in
                    switch response.result {
                    case .success(let trackResponse):
                        switch type {
                        case .artist:
                            if let artistID = trackResponse.artists?.first?.id {
                                completion(artistID)
                            } else {
                                completion(nil)
                            }
                        case .album:
                            if let albumID = trackResponse.album?.id {
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
}

enum IDType {
    case artist, album
}

struct TrackResponse: Decodable {
    let artists: [Artist]?
    let album: Album?
    
    enum CodingKeys: String, CodingKey {
        case artists
        case album
    }
}

struct Artist: Decodable {
    let id: String
    let name: String
}

struct Album: Decodable {
    let id: String
    let name: String
    let artists: [Artist]?
}

enum URIType {
    case song, artist, album
}

struct URIResponse: Decodable {
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case uri
    }
}

struct AccessTokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}

struct Track: Decodable {
    let id: String
    let name: String
    let artists: [Artist]
    let previewURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artists
        case previewURL = "preview_url"
    }
}
