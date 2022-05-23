//
//  MarvelCharacterEndpointTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject
import XCTest

class MarvelCharacterEndpointTests: XCTestCase {
    private var sut: MarvelCharactersEndpoint!

    override func setUp() {
        super.setUp()
        sut = MarvelCharactersEndpoint()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testProperties() {
        // When
        let offset = 0
        let path = "/v1/public/characters"
        let method = HTTPMethod.get

        // Then
        XCTAssertEqual(sut.httpMethod, method)
        XCTAssertEqual(sut.path, path)
        XCTAssertEqual(sut.offset, offset)
    }
}
