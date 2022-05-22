//
//  MarvelCharacterDetailUseCase.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation

protocol MarvelCharacterDetailUseCaseProtocol {
    func execute(identifier: Int) async throws -> Result<MarvelCharacter, NetworkError>
}

class MarvelCharacterDetailUseCase: MarvelCharacterDetailUseCaseProtocol {
    private let marvelRepository: MarvelDataRepositoryProtocol


    public init (marvelRepository: MarvelDataRepositoryProtocol) {
        self.marvelRepository = marvelRepository
    }

    // MARK: - Use Case Method
    func execute(identifier: Int) async throws -> Result<MarvelCharacter, NetworkError> {
        return try await marvelRepository.getMarvelCharacter(identifier: identifier)
    }
}
