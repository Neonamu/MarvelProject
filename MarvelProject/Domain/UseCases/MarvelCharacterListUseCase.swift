//
//  MarvelCharacterListUseCase.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation

protocol MarvelCharacterListUseCaseProtocol {
    func execute(offset: Int) async throws -> Result<[MarvelCharacter], NetworkError>
}

class MarvelCharacterListUseCase: MarvelCharacterListUseCaseProtocol {
    private let marvelRepository: MarvelDataRepositoryProtocol


    public init (marvelRepository: MarvelDataRepositoryProtocol) {
        self.marvelRepository = marvelRepository
    }

    // MARK: - Use case method
    func execute(offset: Int) async throws -> Result<[MarvelCharacter], NetworkError> {
        return try await marvelRepository.getMarvelCharacters(offset: offset)
    }
}
