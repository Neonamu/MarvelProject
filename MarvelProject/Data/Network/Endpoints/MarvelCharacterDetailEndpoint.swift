//
//  MarvelCharacterDetailEndpoint.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation

class MarvelCharacterDetailEndpoint: NetworkEndpointProtocol {
    var headers: [String: String]?

    public var httpMethod = HTTPMethod.get

    var path: String {
        return "/v1/public/characters/\(identifier)"
    }

    var stubPath: String = "/v1/public/character/11111"

    var queryParams: [String: String]? {
        let credentials = MarvelAuthHelper.generateDefaultCredentials()
        return [
            "ts": credentials.ts,
            "hash": credentials.hash,
            "apikey": credentials.apikey]
    }

    var identifier: Int = 0
}
