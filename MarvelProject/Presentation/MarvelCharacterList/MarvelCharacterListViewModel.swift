//
//  MarvelCharacterListViewModel.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation
import Combine

protocol MarveCharacterListViewModelProtocol {
    var dataSource: [MarvelCharacter] { get }
    var dataSourcePublished: Published<[MarvelCharacter]> { get }
    var dataSourcePublisher: Published<[MarvelCharacter]>.Publisher { get }
    func fetchCharacters()
}


class MarvelCharacterListViewModel: MarveCharacterListViewModelProtocol {
    @Published public var dataSource: [MarvelCharacter] = []
    public var dataSourcePublished: Published<[MarvelCharacter]> { _dataSource }
    public var dataSourcePublisher: Published<[MarvelCharacter]>.Publisher { $dataSource }

    private let charactersUseCase: MarvelCharacterListUseCaseProtocol

    private var offset: Int = 0

    public init (charactersUseCase: MarvelCharacterListUseCaseProtocol) {
        self.charactersUseCase = charactersUseCase
    }


    func fetchCharacters() {
        Task { @MainActor in
            let result = try await charactersUseCase.execute(offset: offset)
            switch result {
            case let .success(characters):
                offset += characters.count
                dataSource.append(contentsOf: characters)
            case let .failure(error):
                NSLog("\(error.localizedDescription)")
            }
        }
    }
}
