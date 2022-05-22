//
//  MarvelCharacter.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation

// MARK: - Character
public struct MarvelCharacter: Codable, Hashable {
    let identifier: Int
    let name, resultDescription: String?
    let modified: String?
    let thumbnail: MarvelThumbnail?
    let resourceURI: String?
    let comics: MarvelComics?

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case resultDescription = "description"
        case modified
        case thumbnail
        case resourceURI
        case comics
    }

    public static func == (lhs: MarvelCharacter, rhs: MarvelCharacter) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}

// MARK: - Comics
public struct MarvelComics: Codable {
    let available: Int?
    let collectionURI: String?
    let comicItems: [MarvelComicsItem]?
    let returned: Int?

    enum CodingKeys: String, CodingKey {
        case available
        case collectionURI
        case comicItems = "items"
        case returned
    }
}

// MARK: - Comic Item
public struct MarvelComicsItem: Codable, Hashable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Thumbnail
public struct MarvelThumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}
