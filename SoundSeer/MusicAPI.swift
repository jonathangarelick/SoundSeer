import Alamofire
import Foundation
import OSLog
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

    static func getURI(songId: String, for type: IDType, completion: @escaping (String?) -> Void) {
        guard let authToken = generateAuthToken() else {
            completion(nil)
            return
        }

        let url = "\(baseURL)/catalog/us/songs/\(songId)/\(type == .artist ? "artists" : "albums")"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(authToken)"
        ]

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: ArtistAlbumResponse.self) { response in
                switch response.result {
                case .success(let uriResponse):
                    completion(uriResponse.data.first?.attributes.url)
                case .failure(let error):
                    Logger.api.error("Error getting URI: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }

    // This is pretty hacky, but the artist and album responses have the same shape.
    // This is OK for now, ideally should figure out how to use Apple's built in models
    private struct ArtistAlbumResponse: Codable {
        let data: [ArtistAlbum]
    }

    private struct ArtistAlbum: Codable {
        let attributes: ArtistAlbumAttributes
    }

    private struct ArtistAlbumAttributes: Codable {
        let url: String
    }
}
