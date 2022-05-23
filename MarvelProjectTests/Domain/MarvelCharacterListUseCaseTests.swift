//
//  MarvelCharacterListUseCaseTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject
import XCTest

class MarvelCharacterListUseCaseTests: XCTestCase {
    private var sut: MarvelCharacterListUseCase!
    private var marvelDataRepositoryMock: MarvelDataRepositoryMock!

    override func setUp() {
        super.setUp()
        marvelDataRepositoryMock = MarvelDataRepositoryMock()
        sut = MarvelCharacterListUseCase(marvelRepository: marvelDataRepositoryMock)
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testExecute() async throws {
        // Given
        marvelDataRepositoryMock.stubbedGetMarvelCharactersResult = .success(getCharactersMock())

        // When
        let result = try await marvelDataRepositoryMock.getMarvelCharacters(offset: 0)

        // Then
        XCTAssertNotNil(result)
        switch result {
        case let .success(character):
            XCTAssertEqual(character, getCharactersMock())
            XCTAssertEqual(marvelDataRepositoryMock.invokedGetMarvelCharactersCount, 1)
        case .failure:
            XCTFail("This test must not fail")
        }
    }

    func testError() async throws {
        // Given
        marvelDataRepositoryMock.stubbedGetMarvelCharactersResult = .failure(.httpError(410))

        // When
        let result = try await marvelDataRepositoryMock.getMarvelCharacters(offset: 0)

        // Then
        XCTAssertNotNil(result)
        switch result {
        case .success:
            XCTFail("This test must not fail")
        case let .failure(error):
            XCTAssertEqual(marvelDataRepositoryMock.invokedGetMarvelCharactersCount, 1)
            XCTAssertEqual(error, NetworkError.httpError(410))
        }
    }
}

private extension MarvelCharacterListUseCaseTests {
    func getCharactersMock() -> [MarvelCharacter] {
        [MarvelCharacter(
            identifier: 1,
            name: "test",
            resultDescription: "",
            modified: nil,
            thumbnail: MarvelThumbnail(path: "testPath", thumbnailExtension: ".jpg"),
            resourceURI: nil,
            comics: MarvelComics(
                available: 2,
                collectionURI: nil,
                comicItems: [
                    MarvelComicsItem(
                        resourceURI: "test1",
                        name: "comic1"),
                    MarvelComicsItem(
                        resourceURI: "test2",
                        name: "comic2")],
                returned: 2)),
                  MarvelCharacter(
                    identifier: 2,
                    name: "test2",
                    resultDescription: "",
                    modified: nil,
                    thumbnail: MarvelThumbnail(path: "testPath11", thumbnailExtension: ".jpg"),
                    resourceURI: nil,
                    comics: MarvelComics(
                        available: 2,
                        collectionURI: nil,
                        comicItems: [
                            MarvelComicsItem(
                                resourceURI: "test3",
                                name: "comic3"),
                            MarvelComicsItem(
                                resourceURI: "test4",
                                name: "comic4")],
                        returned: 2))]
    }
}
