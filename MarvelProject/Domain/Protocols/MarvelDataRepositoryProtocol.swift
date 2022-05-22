//
//  MarvelDataRepositoryProtocol.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation
import Combine

protocol MarvelDataRepositoryProtocol {
    func getMarvelCharacters(offset: Int) async throws -> Result<[MarvelCharacter], NetworkError>
    func getMarvelCharacter(identifier: Int) async throws -> Result<MarvelCharacter, NetworkError>
}
