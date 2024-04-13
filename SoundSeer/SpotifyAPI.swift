import Foundation
import Alamofire

// https://nshipster.com/secrets/

class SpotifyAPI {
    static let baseURL = "https://api.spotify.com/v1"
    static let clientID = "d5efe83ecf0043388152717eb2463a1e"
    static let clientSecret = "your-client-secret"

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
                        print("Error getting access token: \(error.localizedDescription)")
                        completion(nil)
                    }
                }
        }
    }

    static func searchTracks(query: String, completion: @escaping ([Track]?) -> Void) {
            getAccessToken { token in
                guard let accessToken = token else {
                    completion(nil)
                    return
                }

                let url = "\(baseURL)/search"
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer \(accessToken)"
                ]
                let parameters: Parameters = [
                    "q": query,
                    "type": "track",
                    "limit": 10
                ]

                AF.request(url, method: .get, parameters: parameters, headers: headers)
                    .validate()
                    .responseDecodable(of: SearchResponse.self) { response in
                        switch response.result {
                        case .success(let searchResponse):
                            completion(searchResponse.tracks.items)
                        case .failure(let error):
                            print("Error searching tracks: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
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

struct SearchResponse: Decodable {
    let tracks: TrackResponse
}

struct TrackResponse: Decodable {
    let items: [Track]
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

struct Artist: Decodable {
    let name: String
}
