//
//  MarvelAuthHelper.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation

struct MarvelAuthEntity: Encodable {
    var ts = String(Date().timeIntervalSince1970)
    var hash: String
    var apikey: String
}

class MarvelAuthHelper {
    private static func generateCredentials(publicKey: String, privateKey: String) -> MarvelAuthEntity {
        let ts = String(Date().timeIntervalSince1970)
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        return MarvelAuthEntity(ts: ts, hash: hash, apikey: publicKey)
    }

    static func generateDefaultCredentials() -> MarvelAuthEntity {
        let publicKey = "22e2353e636f9070970aa3f35f7d1c9f"
        let privateKey = "57a54bb45871e057987276e9a06caef9493274f6"
        return generateCredentials(publicKey: publicKey, privateKey: privateKey)
    }
}