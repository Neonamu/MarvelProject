//
//  MarvelCharacterListUseCaseMock.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject

final class MarvelCharacterListUseCaseMock: MarvelCharacterListUseCaseProtocol{

    var invokedExecute = false
    var invokedExecuteCount = 0
    var invokedExecuteParameters: (offset: Int, Void)?
    var invokedExecuteParametersList = [(offset: Int, Void)]()
    var stubbedExecuteResult: Result<[MarvelCharacter], NetworkError>!

    func execute(offset: Int) async throws  -> Result<[MarvelCharacter], NetworkError> {
        invokedExecute = true
        invokedExecuteCount += 1
        invokedExecuteParameters = (offset, ())
        invokedExecuteParametersList.append((offset, ()))
        return stubbedExecuteResult
    }
}
