//
//  Resources.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation
import UIKit

enum Resources {

    // MARK: Internal

    enum Login {
        static func getMe() -> Resource<User> {
            Resources.createFor(url: .init(from: "/me")!, httpMethod: .get)
        }
    }

    enum Folder {

        static func getMe() -> Resource<User> {
            Resources.createFor(url: .init(from: "/me")!, httpMethod: .get)
        }

        static func getDirectoryContentFor(id: String) -> Resource<[Item]> {
            Resources.createFor(url: .init(from: "/items/\(id)")!, httpMethod: .get)
        }

        static func createFolderFor(for id: String, folderName: NewFolderRequest) -> Resource<Item> {
            Resources.createFor(url: .init(from: "/items/\(id)")!, httpMethod: .post(folderName))
        }

        static func deleteItem(for id: String) -> VoidResource {
            Resources.createVoidResouce(url: .init(from: "/items/\(id)")!, httpMethod: .delete)
        }

        static func loadImage(for id: String) -> Resource<Data> {
            Resources.createFor(url: .init(from: "/items/\(id)/data")!, httpMethod: .get)
        }
    }

    static func uploadImage(for data: Data, toFolder: String, withName: String) -> Resource<Item> {
        var resouce: Resource<Item> = Resources
            .createFor(urlForUpload: .init(from: "/items/\(toFolder)")!, httpMethod: .post(data))
        resouce.request.allHTTPHeaderFields = [
            "Content-Type": "application/octet-stream",
            "Content-Disposition": "attachment;filename*=utf-8''\(withName).jpg"
        ]
        return resouce
    }

    // MARK: Private

    private static func createFor<T: Decodable>(url: URL, httpMethod: HTTPMethod) -> Resource<T> {
        var request = createURLRequestFor(url: url, httpMethod: httpMethod)
        if case let .post(body) = httpMethod, let safeBody = body {
            request.httpBody = safeBody.toJSONData()
            request.allHTTPHeaderFields = [
                "Content-Type": "application/json"
            ]
        }
        return Resource(request: request, responseType: T.self)
    }

    private static func createFor<T: Decodable>(urlForUpload: URL, httpMethod: HTTPMethod) -> Resource<T> {
        var request = createURLRequestFor(url: urlForUpload, httpMethod: httpMethod)
        if case let .post(body) = httpMethod, let safeBody = body {
            request.httpBody = safeBody as? Data
        }
        return Resource(request: request, responseType: T.self)
    }

    private static func createVoidResouce(url: URL, httpMethod: HTTPMethod) -> VoidResource {
        var request = createURLRequestFor(url: url, httpMethod: httpMethod)
        if case let .post(body) = httpMethod, let safeBody = body {
            request.httpBody = safeBody as? Data
        }
        return VoidResource(request: request)
    }

    private static func createURLRequestFor(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.string

        let data = "\(SessionStorage.shared.credentials.username):\(SessionStorage.shared.credentials.password)"
            .data(using: String.Encoding.utf8)!
        let base64 = data.base64EncodedString()
        urlRequest.setValue("Basic \(base64)", forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

extension URL {
    init?(from path: String, requireAuthentication _: Bool = false) {
        guard var urlComponents = URLComponents(string: ApiConstants.baseUrl) else { return nil }
        urlComponents.path = path
        guard let url = urlComponents.url else { return nil }
        self = url
    }
}
