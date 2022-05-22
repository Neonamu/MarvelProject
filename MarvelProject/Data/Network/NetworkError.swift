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
}
