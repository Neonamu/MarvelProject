//
//  MarvelCharacterDetailUseCaseMock.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject

final class MarvelCharacterDetailUseCaseMock: MarvelCharacterDetailUseCaseProtocol {
    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (identifier: Int, Void)?
    var invokedExecuteParametersList = [(identifier: Int, Void)]()
    var stubbedExecuteResult: Result<MarvelCharacter, NetworkError>!

    func execute(identifier: Int) -> Result<MarvelCharacter, NetworkError> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (identifier, ())
        invokedExecuteParametersList.append((identifier, ()))
        return stubbedExecuteResult
    }
}
