//
//  NetworkService.swift
//  MyFolder
//
//  Created by Peter Lizak on 18/01/2023.
//

import Foundation
import os.log

protocol NetworkServicing {
    func load<T>(resource: Resource<T>) async -> Result<T, AppError>
    func loadDataFrom(resource: Resource<Data>) async -> Result<Data, AppError>
    func loadVoid(resource: VoidResource) async -> Result<Void, AppError>
}

class NetworkService: NetworkServicing {

    // MARK: Lifecycle

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    // MARK: Internal

    func load<T>(resource: Resource<T>) async -> Result<T, AppError> {
        do {
            print("\(resource.request.description)")
            let (data, response) = try await session.data(for: resource.request)

            print(response)
            guard let response = response as? HTTPURLResponse else {
                throw AppError.network(type: .invalidResponse)
            }

            if response.statusCode == 401 {
                throw AppError.network(type: .unauthenticated)
            }

            if !(200 ..< 300 ~= response.statusCode) {
                throw AppError.network(
                    type: .custom(
                        errorCode: response.statusCode,
                        errorDescription: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))
            }

            let result = try decoder.decode(resource.responseType, from: data)
            return .success(result)

        } catch {
            if let appError = lookForErrorTypeIn(error: error) {
                return .failure(appError)
            }
            return .failure(.network(type: .unknown(error: error)))
        }
    }

    func loadVoid(resource: VoidResource) async -> Result<Void, AppError> {
        do {
            print("\(resource.request.description)")
            let (_, response) = try await session.data(for: resource.request)

            if let error = lookForError(in: response) {
                return .failure(error)
            }
            return .success(())

        } catch {
            if let appError = lookForErrorTypeIn(error: error) {
                return .failure(appError)
            }
            return .failure(.network(type: .unknown(error: error)))
        }
    }

    func loadDataFrom(resource: Resource<Data>) async -> Result<Data, AppError> {
        do {
            let (data, response) = try await session.data(for: resource.request)
            if let error = lookForError(in: response) {
                return .failure(error)
            }
            return .success(data)
        } catch {
            if let appError = lookForErrorTypeIn(error: error) {
                return .failure(appError)
            }
            return .failure(.network(type: .unknown(error: error)))
        }
    }

    // MARK: Private

    private let session: URLSession
    private let decoder: JSONDecoder

    // MARK: - Private, error handling

    private func lookForError(in response: URLResponse) -> AppError? {
        guard let response = response as? HTTPURLResponse else {
            return AppError.network(type: .invalidResponse)
        }

        if response.statusCode == 401 {
            return AppError.network(type: .unauthenticated)
        }

        if !(200 ..< 300 ~= response.statusCode) {
            return AppError.network(
                type: .custom(
                    errorCode: response.statusCode,
                    errorDescription: HTTPURLResponse.localizedString(forStatusCode: response.statusCode)))
        }
        return nil
    }

    private func lookForErrorTypeIn(error: Error) -> AppError? {
        let error = error as NSError
        if error.domain == NSURLErrorDomain, error.code == NSURLErrorNotConnectedToInternet {
            return AppError.network(type: .noInternet)
        } else if error is DecodingError {
            return AppError.network(type: .parsing(error: error))
        } else {
            return AppError.network(type: .unknown(error: error))
        }
    }
}
