import Alamofire
import Foundation
import OSLog

class SpotifyAPI {
    private static let baseURL = "https://api.spotify.com/v1"
    private static var token: String?
    private static var tokenExpiration: Date?
    
    static func getAccessToken(completion: @escaping (String?) -> Void) {
        if let token = token, let expiration = tokenExpiration, expiration > Date() {
            // Token is still valid, use the cached token
            completion(token)
        } else {
            // Token has expired or is not available, request a new token
            let url = "https://accounts.spotify.com/api/token"
            let headers: HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters: Parameters = [
                "grant_type": "client_credentials",
                "client_id": Secrets.Spotify.clientID,
                "client_secret": Secrets.Spotify.clientSecret
            ]
            
            AF.request(url, method: .post, parameters: parameters, headers: headers)
                .validate()
                .responseDecodable(of: AccessTokenResponse.self) { response in
                    switch response.result {
                    case .success(let tokenResponse):
                        token = tokenResponse.accessToken
                        tokenExpiration = Date().addingTimeInterval(TimeInterval(tokenResponse.expiresIn))
                        completion(token)
                    case .failure(let error):
                        Logger.api.error("Error getting access token: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    }
    
    static func getURI(songId: String, for type: URIType, completion: @escaping (URL?) -> Void) {
        getID(from: songId, for: type) { id in
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
                }
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)"
                ]
                
                AF.request(url, method: .get, headers: headers)
                    .validate()
                    .responseDecodable(of: URIResponse.self) { response in
                        switch response.result {
                        case .success(let uriResponse):
                            completion(URL(string: uriResponse.uri))
                        case .failure(let error):
                            Logger.api.error("Error getting URI: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
            }
        }
    }
    
    private static func getID(from songID: String, for type: URIType, completion: @escaping (String?) -> Void) {
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

struct APITrack: Decodable {
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
