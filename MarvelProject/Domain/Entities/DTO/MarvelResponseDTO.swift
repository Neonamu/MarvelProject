//
//  MarvelResponseDTO.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation

public struct MarvelResponseDTO: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: MarvelDataClassDto?
}

public struct MarvelDataClassDto: Codable {
    let offset, limit, total, count: Int?
    let results: [MarvelCharacter]?
}
