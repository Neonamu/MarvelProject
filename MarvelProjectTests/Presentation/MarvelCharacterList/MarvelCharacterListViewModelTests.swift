//
//  MarvelCharacterListViewModelTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject
import XCTest
import Combine

class MarvelCharacterListViewModelTests: XCTestCase{
    private var sut: MarvelCharacterListViewModel!
    private var marveCharacterListUseCaseMock : MarvelCharacterListUseCaseMock!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        marveCharacterListUseCaseMock = MarvelCharacterListUseCaseMock()
        sut = MarvelCharacterListViewModel(charactersUseCase: marveCharacterListUseCaseMock)
    }
    
    func testInit(){
        XCTAssertNotNil(sut)
    }
    
    func testFetchCharacters(){
        // Given
        let charactersMock = getCharactersMock()
        marveCharacterListUseCaseMock.stubbedExecuteResult = .success(charactersMock)
        XCTAssertTrue(sut.dataSource.isEmpty)
        let exp = expectation(description: "fetchCharacters")
        
        // When
        sut.fetchCharacters()
        
        // then
        sut.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { characters in
                if !characters.isEmpty{
                    XCTAssertEqual(self.marveCharacterListUseCaseMock.invokedExecuteCount, 1)
                    XCTAssertEqual(characters, charactersMock)
                    exp.fulfill()
                }
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
    }
    
    func testOffset(){
        // Given
        let charactersMock = getCharactersMock()
        marveCharacterListUseCaseMock.stubbedExecuteResult = .success(charactersMock)
        sut.dataSource = getCharactersMock()
        let exp = expectation(description: "fetchCharacters")
        
        // When
        sut.fetchCharacters()
        
        // then
        sut.dataSourcePublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { characters in
                if !characters.isEmpty && self.sut.dataSource.count == 4{
                    XCTAssertEqual(self.marveCharacterListUseCaseMock.invokedExecuteCount, 1)
                    XCTAssertEqual(characters, self.sut.dataSource)
                    exp.fulfill()
                }
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 3)
    }
}

private extension MarvelCharacterListViewModelTests{
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
