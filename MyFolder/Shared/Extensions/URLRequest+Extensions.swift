//
//  URLRequest+Extensions.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation

extension URLRequest {
    var description: String {
        #if !DEBUG
        return ""
        #else
        var result = "curl -k "

        if let method = httpMethod {
            result += "-X \(method) \\\n"
        }

        if let headers = allHTTPHeaderFields {
            for (header, value) in headers where header != "Cookie" {
                result += "-H \"\(header): \(value)\" \\\n"
            }
        }

        if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8) {
            result += "-d '\(string)' \\\n"
        }

        if let url = url {
            result += url.absoluteString
        }

        return result
        #endif
    }
}
