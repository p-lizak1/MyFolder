//
//  AppError.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation

enum AppError {
    case network(type: Enums.NetworkError)
    case custom(errorDescription: String?)

    class Enums {}
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .network(type):
            return type.localizedDescription
        case let .custom(errorDescription):
            return errorDescription
        }
    }
}

extension AppError.Enums {
    enum NetworkError {
        case invalidResponse
        case noInternet
        case unauthenticated
        case parsing(error: Error)
        case custom(errorCode: Int?, errorDescription: String?)
        case unknown(error: Error?)
    }
}

extension AppError.Enums.NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternet: return "No Internet"
        case .invalidResponse: return "Invalid response"
        case .unauthenticated: return "Unauthenticated User"
        case let .parsing(error): return "Parsing error: \(error)"
        case let .custom(_, errorDescription): return errorDescription
        case let .unknown(error): return "Unknown error: \(error?.localizedDescription ?? "")"
        }
    }

    var errorCode: Int? {
        switch self {
        case .noInternet: return nil
        case .invalidResponse: return nil
        case .unauthenticated: return nil
        case .parsing: return nil
        case let .custom(errorCode, _): return errorCode
        case .unknown: return nil
        }
    }
}
