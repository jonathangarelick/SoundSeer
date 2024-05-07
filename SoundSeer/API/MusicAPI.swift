import Alamofire
import OSLog
import SwiftJWT

// TODO: get song id and album id functions for initial loading

class MusicAPI: PlayerAPI {
    private static let baseURL = "https://api.music.apple.com/v1"
    private static var token: String?
    private static var tokenExpiration: Date?

    private static func generateToken() -> String? {
        if let token = token, let expiration = tokenExpiration, expiration > Date() {
            return token
        }

        let timeNow = Date()
        let timeExpired = timeNow.addingTimeInterval(12 * 60 * 60) // 12 hours from now

        var jwt = JWT(
            header: SwiftJWT.Header(kid: Secrets.Music.keyId),
            claims: ClaimsStandardJWT(iss: Secrets.Music.teamId, exp: timeExpired, iat: timeNow)
        )

        do {
            let privateKey = JWTSigner.es256(privateKey: Secrets.Music.secret.data(using: .utf8)!)
            let signedJWT = try jwt.sign(using: privateKey)
            return signedJWT
        } catch {
            Logger.api.error("Error generating auth token: \(error.localizedDescription)")
            return nil
        }
    }

    static func getURI(songId: String, for type: URIType, completion: @escaping (URL?) -> Void) {
        guard let authToken = generateToken() else {
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
                if let urlString = uriResponse.data.first?.attributes.url {
                   completion(URL(string: urlString))
                } else {
                    completion(nil)
                }
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
