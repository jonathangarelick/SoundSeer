import Foundation

enum URIType {
    case album, artist
}

protocol PlayerAPI {
    static func getURI(songId: String, for type: URIType, completion: @escaping (URL?) -> Void)
}
