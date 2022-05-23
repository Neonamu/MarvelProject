//
//  NetworkError.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

public enum NetworkError: Error, Equatable {
    case decodingError
    case httpError(Int)
    case invalidURL
    case unknown

    public var errorDescription: String {
        switch self {
        case .unknown:
            return "Unknown error"
        case .invalidURL:
            return "Invalid URL"
        case .decodingError:
            return "Error decoding data"
        case let .httpError(numError):
            return "HTTP Error \(numError)"
        @unknown default:
            return "Unknown error"
        }
    }
}
