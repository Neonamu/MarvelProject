//
//  MarvelCharacterDetailViewModel.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 20/5/22.
//

import Foundation
import Combine

protocol MarvelCharacterDetailViewModelProtocol {
    var dataSource: MarvelCharacter? { get }
    var dataSourcePublisher: Published<MarvelCharacter?>.Publisher { get }
    func fetchCharacter()
}


class MarvelCharacterDetailViewModel: MarvelCharacterDetailViewModelProtocol {
    @Published public var dataSource: MarvelCharacter?
    public var dataSourcePublished: Published<MarvelCharacter?> { _dataSource }
    public var dataSourcePublisher: Published<MarvelCharacter?>.Publisher { $dataSource }

    private let characterDetailUseCase: MarvelCharacterDetailUseCaseProtocol

    private var identifier: Int

    public init (characterDetailUseCase: MarvelCharacterDetailUseCaseProtocol, identifier: Int) {
        self.identifier = identifier
        self.characterDetailUseCase = characterDetailUseCase
    }


    func fetchCharacter() {
        Task { @MainActor in
            let result = try await characterDetailUseCase.execute(identifier: identifier)
            switch result {
            case let .success(character):
                dataSource = character
            case let .failure(error):
                NSLog("\(error.localizedDescription)")
            }
        }
    }
}
