//
//  MarvelCharacterDetailViewModelTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject
import XCTest
import Combine

class MarvelCharacterDetailViewModelTests: XCTestCase{
    private var sut: MarvelCharacterDetailViewModel!
    private var marvelDetailUseCase : MarvelCharacterDetailUseCaseMock!
    private var identifier = 1
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        marvelDetailUseCase = MarvelCharacterDetailUseCaseMock()
        sut = MarvelCharacterDetailViewModel(characterDetailUseCase: marvelDetailUseCase, identifier: identifier)
    }
    
    func testInit(){
        XCTAssertNotNil(sut)
    }
    
    func testFetchCharacter(){
        // Given
        let charactersMock = getCharacterMock()
        marvelDetailUseCase.stubbedExecuteResult = .success(charactersMock)
        XCTAssertNil(sut.dataSource)
        let exp = expectation(description: "fetchCharacter")
        
        // When
        sut.fetchCharacter()
        
        // then
        sut.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { characters in
                if let characters = characters {
                    XCTAssertEqual(characters, self.sut.dataSource)
                    XCTAssertEqual(self.marvelDetailUseCase.invokedExecuteCount, 1)
                    exp.fulfill()
                }
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
    }
}

private extension MarvelCharacterDetailViewModelTests{
    func getCharacterMock() -> MarvelCharacter {
        MarvelCharacter(
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
                returned: 2))
    }
}
