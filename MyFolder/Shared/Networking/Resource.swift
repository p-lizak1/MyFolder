//
//  Resource.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation

enum HTTPMethod {
    case get
    case post(Encodable?)
    case put(Encodable)
    case patch(Encodable)
    case delete
}

extension HTTPMethod {
    var string: String {
        switch self {
        case .get: return "get"
        case .post: return "post"
        case .put: return "put"
        case .patch: return "patch"
        case .delete: return "delete"
        }
    }
}

struct Resource<T: Decodable> {
    var request: URLRequest
    let responseType: T.Type
}

struct VoidResource {
    var request: URLRequest
}

struct NewFolderRequest: Codable {
    var name: String
}

extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
