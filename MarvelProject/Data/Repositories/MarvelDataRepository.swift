//
//  MarvelDataRepository.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 18/5/22.
//

import Foundation

class MarvelDataRepository: MarvelDataRepositoryProtocol {
    private let networkService: AsyncAwaitNetworkServiceProtocol

    public init(networkService: AsyncAwaitNetworkServiceProtocol) {
        self.networkService = networkService
    }

    func getMarvelCharacters(offset: Int = 0) async throws -> Result<[MarvelCharacter], NetworkError> {
        let endpoint = MarvelCharactersEndpoint()
        endpoint.offset = offset

        do {
            let result: MarvelResponseDTO = try await networkService.request(with: endpoint)
            guard let characters = result.data?.results else {
                return .failure(.unknown)
            }
            return .success(characters)
        } catch let error as NetworkError {
            return .failure(error)
        }
    }

    func getMarvelCharacter(identifier: Int) async throws -> Result<MarvelCharacter, NetworkError> {
        let endpoint = MarvelCharacterDetailEndpoint()
        endpoint.identifier = identifier

        do {
            let result: MarvelResponseDTO = try await networkService.request(with: endpoint)
            guard let character = result.data?.results?.first else {
                return .failure(.unknown)
            }
            return .success(character)
        } catch let error as NetworkError {
            return .failure(error)
        }
    }
}
