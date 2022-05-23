//
//  MarvelCharacterDetailUseCaseTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//


@testable import MarvelProject
import XCTest

class MarvelCharacterDetailUseCaseTests: XCTestCase {
    private var sut: MarvelCharacterDetailUseCase!
    private var marvelDataRepositoryMock: MarvelDataRepositoryMock!

    override func setUp() {
        super.setUp()
        marvelDataRepositoryMock = MarvelDataRepositoryMock()
        sut = MarvelCharacterDetailUseCase(marvelRepository: marvelDataRepositoryMock)
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testExecute() async throws {
        let identifier = 1
        marvelDataRepositoryMock.stubbedGetMarvelCharacterResult = .success(getCharactersMock())

        let result = try await marvelDataRepositoryMock.getMarvelCharacter(identifier: identifier)

        XCTAssertNotNil(result)
        switch result {
        case let .success(character):
            XCTAssertEqual(character, getCharactersMock())
            XCTAssertEqual(marvelDataRepositoryMock.invokedGetMarvelCharacterCount, 1)
        case .failure:
            XCTFail("This test must not fail")
        }
    }

    func testError() async throws {
        let identifier = 1
        marvelDataRepositoryMock.stubbedGetMarvelCharacterResult = .failure(.httpError(411))

        let result = try await marvelDataRepositoryMock.getMarvelCharacter(identifier: identifier)

        XCTAssertNotNil(result)
        switch result {
        case .success:
            XCTFail("This test must not fail")
        case let .failure(error):
            XCTAssertEqual(marvelDataRepositoryMock.invokedGetMarvelCharacterCount, 1)
            XCTAssertEqual(error, NetworkError.httpError(411))
        }
    }
}

private extension MarvelCharacterDetailUseCaseTests {
    func getCharactersMock() -> MarvelCharacter {
        MarvelCharacter(
            identifier: 1,
            name: "test",
            resultDescription: "",
            modified: nil,
            thumbnail: MarvelThumbnail(path: "testPath", thumbnailExtension: ".jpg"),
            resourceURI: nil,
            comics: MarvelComics(
                available: 1,
                collectionURI: nil,
                comicItems: [
                    MarvelComicsItem(
                        resourceURI: "test1",
                        name: "comic1"),
                    MarvelComicsItem(
                        resourceURI: "test2",
                        name: "comic2")],
                returned: 2))
    }
}
