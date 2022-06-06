//
//  MarvelCharacterListViewModel.swift
//  MarvelProject
//
//  Created by Manuel Alvarez Marin on 19/5/22.
//

import Foundation
import Combine

protocol MarvelCharacterListViewModelProtocol {
    var dataSource: [MarvelCharacter] { get }
    var dataSourcePublisher: Published<[MarvelCharacter]>.Publisher { get }
    var errorMsg: String { get }
    var errorMsgPublisher: Published<String>.Publisher { get }
    func fetchCharacters()
    func reloadAllData()
}


class MarvelCharacterListViewModel: MarvelCharacterListViewModelProtocol {
    @Published public var dataSource: [MarvelCharacter] = []
    public var dataSourcePublisher: Published<[MarvelCharacter]>.Publisher { $dataSource }

    @Published public var errorMsg: String = ""
    public var errorMsgPublisher: Published<String>.Publisher { $errorMsg }

    private let charactersUseCase: MarvelCharacterListUseCaseProtocol

    private var offset: Int = 0
    private var mustSearch = true

    public init (charactersUseCase: MarvelCharacterListUseCaseProtocol) {
        self.charactersUseCase = charactersUseCase
    }


    func fetchCharacters() {
        if !mustSearch { return }
        Task { @MainActor in
            let result = try await charactersUseCase.execute(offset: offset)

            switch result {
            case let .success(characters):
                if characters.isEmpty {
                    mustSearch = false
                }
                offset += characters.count
                dataSource.append(contentsOf: characters)
                errorMsg = ""
            case let .failure(error):
                errorMsg = error.errorDescription
            }
        }
    }

    func reloadAllData() {
        offset = 0
        mustSearch = true
        dataSource = []
        errorMsg = ""
        fetchCharacters()
    }
}
