//
//  MarvelEndpoint.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

class MarvelCharactersEndpoint: NetworkEndpointProtocol {
    var headers: [String: String]?

    public var httpMethod = HTTPMethod.get

    var path: String = "/v1/public/characters"

    var stubPath: String = "/v1/public/characters"

    var queryParams: [String: String]? {
        let credentials = MarvelAuthHelper.generateDefaultCredentials()
        return [
            "ts": credentials.ts,
            "hash": credentials.hash,
            "apikey": credentials.apikey,
            "offset": String(offset)]
    }

    var offset: Int = 0
}
