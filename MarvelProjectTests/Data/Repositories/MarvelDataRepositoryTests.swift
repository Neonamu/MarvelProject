//
//  MarvelDataRepositoryTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

import Combine
@testable import MarvelProject
import XCTest

class MarvelDataRepositoryTests: XCTestCase {
    private var sut: MarvelDataRepository!
    private var networkServiceMock: NetworkServiceMock!

    override func setUp() {
        super.setUp()
        networkServiceMock = NetworkServiceMock()
        sut = MarvelDataRepository(networkService: networkServiceMock)
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testCharacterList() async throws {
        // Given
        let marvelResponse = getMarvelResponseMock()
        networkServiceMock.invokedRequestResult = marvelResponse

        // When
        let result = try await sut.getMarvelCharacters()

        // Then
        XCTAssertNotNil(result)
        switch result {
        case let .success(characters):
            XCTAssertEqual(networkServiceMock.invokedRequestCount, 1)
            XCTAssertEqual(characters.count, 2)
        case .failure:
            XCTFail("this test must not fail")
        }
    }

    func testCharacterDetail() async throws {
        // Given
        let identifier = 1
        let marvelResponse = getMarvelResponseCharacterDetailMock()
        networkServiceMock.invokedRequestResult = marvelResponse

        // When
        let result = try await sut.getMarvelCharacter(identifier: identifier)

        // Then
        XCTAssertNotNil(result)
        switch result {
        case let .success(character):
            XCTAssertEqual(networkServiceMock.invokedRequestCount, 1)
            XCTAssertEqual(character.identifier, identifier)
            XCTAssertEqual(character.name, "test1Detail")
        case .failure:
            XCTFail("this test must not fail")
        }
    }

    func testError() async throws {
        // Given
        networkServiceMock.invokedRequestError = .httpError(405)

        // When
        let result = try await sut.getMarvelCharacters()

        // Then
        XCTAssertNotNil(result)
        switch result {
        case .success:
            XCTFail("this test must fail")
        case let .failure(error):
            XCTAssertEqual(error, NetworkError.httpError(405))
        }
    }
}

private extension MarvelDataRepositoryTests {
    func getMarvelResponseCharacterDetailMock() -> MarvelResponseDTO {
        MarvelResponseDTO(
            code: 200,
            status: "ok",
            copyright: "",
            attributionText: "",
            attributionHTML: "",
            etag: "",
            data: MarvelDataClassDto(
                offset: 0,
                limit: 1,
                total: 1,
                count: 1,
                results: [MarvelCharacter(
                    identifier: 1,
                    name: "test1Detail",
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
                        returned: 2))]))
    }

    func getMarvelResponseMock() -> MarvelResponseDTO {
        MarvelResponseDTO(
            code: 200,
            status: "ok",
            copyright: "",
            attributionText: "",
            attributionHTML: "",
            etag: "",
            data: MarvelDataClassDto(
                offset: 0,
                limit: 2,
                total: 1500,
                count: 2,
                results: [MarvelCharacter(
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
                                returned: 2))]))
    }
}
