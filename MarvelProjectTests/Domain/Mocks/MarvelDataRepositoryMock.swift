//
//  MarvelDataRepositoryMock.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject

final class MarvelDataRepositoryMock: MarvelDataRepositoryProtocol{

    var invokedGetMarvelCharacters = false
    var invokedGetMarvelCharactersCount = 0
    var invokedGetMarvelCharactersParameters: (offset: Int, Void)?
    var invokedGetMarvelCharactersParametersList = [(offset: Int, Void)]()
    var stubbedGetMarvelCharactersResult: Result<[MarvelCharacter], NetworkError>!

    func getMarvelCharacters(offset: Int) async throws  -> Result<[MarvelCharacter], NetworkError> {
        invokedGetMarvelCharacters = true
        invokedGetMarvelCharactersCount += 1
        invokedGetMarvelCharactersParameters = (offset, ())
        invokedGetMarvelCharactersParametersList.append((offset, ()))
        return stubbedGetMarvelCharactersResult
    }

    var invokedGetMarvelCharacter = false
    var invokedGetMarvelCharacterCount = 0
    var invokedGetMarvelCharacterParameters: (identifier: Int, Void)?
    var invokedGetMarvelCharacterParametersList = [(identifier: Int, Void)]()
    var stubbedGetMarvelCharacterResult: Result<MarvelCharacter, NetworkError>!

    func getMarvelCharacter(identifier: Int) async throws -> Result<MarvelCharacter, NetworkError> {
        invokedGetMarvelCharacter = true
        invokedGetMarvelCharacterCount += 1
        invokedGetMarvelCharacterParameters = (identifier, ())
        invokedGetMarvelCharacterParametersList.append((identifier, ()))
        return stubbedGetMarvelCharacterResult
    }
}
