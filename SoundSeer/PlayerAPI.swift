import Foundation

protocol PlayerAPI {
    static func getPlayerURI(for: URIType, completion: @escaping (String?) -> Void) -> URL
}
