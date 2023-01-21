//
//  NetworkingServiceMock.swift
//  MyFolderTests
//
//  Created by Peter Lizak on 19/01/2023.
//

import Foundation
@testable import MyFolder

// swiftlint:disable force_try
class NetworkingServiceMock: NetworkServicing {

    // MARK: Lifecycle

    init(returnData: Data) {
        self.returnData = returnData
    }

    // MARK: Internal

    var returnData: Data

    func load<T>(resource: MyFolder.Resource<T>) async -> Result<T, MyFolder.AppError> where T: Decodable {
        let result = try! JSONDecoder().decode(resource.responseType, from: returnData)
        return .success(result)
    }

    func loadDataFrom(resource: MyFolder.Resource<Data>) async -> Result<Data, MyFolder.AppError> {
        .success(Data())
    }

    func loadVoid(resource: MyFolder.VoidResource) async -> Result<Void, MyFolder.AppError> {
        .success(())
    }
}
