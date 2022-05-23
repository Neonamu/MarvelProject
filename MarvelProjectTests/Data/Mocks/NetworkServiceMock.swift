//
//  NetworkServiceMock.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

import Foundation
@testable import MarvelProject

final class NetworkServiceMock: AsyncAwaitNetworkServiceProtocol {
    var invokedRequest = false
    var invokedRequestCount = 0
    var invokedRequestParameters: (endpoint: NetworkEndpointProtocol, Void)?
    var invokedRequestParametersList = [(endpoint: NetworkEndpointProtocol, Void)]()
    var invokedRequestResult: Any!
    var invokedRequestError: NetworkError?

    func request<T: Decodable>(with endpoint: NetworkEndpointProtocol) async throws -> T {
        invokedRequest = true
        invokedRequestCount += 1
        invokedRequestParameters = (endpoint, ())
        invokedRequestParametersList.append((endpoint, ()))

        if let invokedRequestError = invokedRequestError {
            throw invokedRequestError
        }

        guard let result = invokedRequestResult as? T else {
            throw NetworkError.decodingError
        }

        return result
    }

    var invokedRequestImage = false
    var invokedRequestImageCount = 0
    var invokedRequestImageParameters: (endpoint: NetworkEndpointProtocol, Void)?
    var invokedRequestImageParametersList = [(endpoint: NetworkEndpointProtocol, Void)]()
    var invokedRequestImageResult: Data!
    var invokedRequestImageError: NetworkError?

    func requestImage(with endpoint: NetworkEndpointProtocol) async throws -> Data {
        invokedRequestImage = true
        invokedRequestImageCount += 1
        invokedRequestImageParameters = (endpoint, ())
        invokedRequestImageParametersList.append((endpoint, ()))
        if let invokedRequestImageError = invokedRequestImageError {
            throw invokedRequestImageError
        }
        return invokedRequestImageResult
    }
}
