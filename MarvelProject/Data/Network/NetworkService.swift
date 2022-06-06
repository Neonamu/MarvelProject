//
//  NetworkService.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift

public protocol AsyncAwaitNetworkServiceProtocol {
    func request<T: Decodable>(with endpoint: NetworkEndpointProtocol) async throws -> T
    func requestImage(with endpoint: NetworkEndpointProtocol) async throws -> Data
}

public final class AsyncAwaitNetworkService: NSObject, AsyncAwaitNetworkServiceProtocol {
    let environment: NetworkEnvironmentProtocol
    let logger: NetworkServiceLoggerProtocol
    private lazy var session: URLSession = .init(configuration: .default, delegate: self, delegateQueue: nil)

    public init(environment: NetworkEnvironmentProtocol, logger: NetworkServiceLoggerProtocol) {
        self.environment = environment
        self.logger = logger
        super.init()
    }

    // MARK: - Request. return Type T
    public func request<T: Decodable>(with endpoint: NetworkEndpointProtocol) async throws -> T {
        guard let session = initializeSession(with: endpoint), let urlRequest = urlRequest(endpoint: endpoint) else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await session.data(for: urlRequest)
            logResponseIfNeeded(data: data, response: response)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            guard (200 ... 299).contains(response.statusCode) else {
                throw NetworkError.httpError(response.statusCode)
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw NetworkError.unknown
        }
    }

    // MARK: - Request. Return image
    public func requestImage(with endpoint: NetworkEndpointProtocol) async throws -> Data {
        guard let session = initializeSession(with: endpoint), let urlRequest = urlRequest(endpoint: endpoint) else {
            throw NetworkError.invalidURL
        }
        do {
            let (data, response) = try await session.data(for: urlRequest)
            logResponseIfNeeded(data: data, response: response)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            guard (200 ... 299).contains(response.statusCode) else {
                throw NetworkError.httpError(response.statusCode)
            }

            guard response.value(forHTTPHeaderField: "Content-Type") == "image/png" ||
                    response.value(forHTTPHeaderField: "Content-Type") == "image/jpg"
            else {
                throw NetworkError.decodingError
            }

            return data
        } catch {
            throw NetworkError.unknown
        }
    }
}

// MARK: - URLSessionDelegate
extension AsyncAwaitNetworkService: URLSessionDelegate {
    public func urlSession(
        _: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        let serverTrust = environment.serverTrust
        let disposition: URLSession.AuthChallengeDisposition = serverTrust ? .performDefaultHandling : .useCredential
        if let challengeServerTrust = challenge.protectionSpace.serverTrust {
            completionHandler(disposition, URLCredential(trust: challengeServerTrust))
        } else {
            completionHandler(disposition, nil)
        }
    }
}

// MARK: - Configuration methods
private extension AsyncAwaitNetworkService {
    func initializeSession(with endpoint: NetworkEndpointProtocol) -> URLSession? {
        guard let urlRequest = urlRequest(endpoint: endpoint) else { return nil }

        activateStubModeIfNeeded(endpoint)
        logRequestIfNeeded(urlRequest)
        return session
    }

    func activateStubModeIfNeeded(_ endpoint: NetworkEndpointProtocol) {
        guard environment.stubMode else { return }
        stub(condition: isPath(endpoint.path)) { _ in
            HTTPStubsResponse(fileAtPath: endpoint.stubPath, statusCode: 200, headers: nil)
        }
    }

    func logRequestIfNeeded(_ urlRequest: URLRequest) {
        guard environment.logMode else { return }
        logger.logRequest(urlRequest)
    }

    func logResponseIfNeeded(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        guard environment.logMode else { return }
        logger.logResponse(data, response, error)
    }

    func urlRequest(endpoint: NetworkEndpointProtocol) -> URLRequest? {
        var urlComponents = URLComponents(string: environment.baseURL + endpoint.path)
        urlComponents?.queryItems = endpoint.queryParams?.reduce(into: []) { result, item in
            result.append(URLQueryItem(name: item.key, value: item.value))
        }

        guard let url = urlComponents?.url else {
            return nil
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = endpoint.cachePolicy
        urlRequest.timeoutInterval = environment.timeoutInterval
        urlRequest.httpMethod = endpoint.httpMethod.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = endpoint.headers
        urlRequest.httpBody = endpoint.httpBody

        return urlRequest
    }
}
