//
//  ImageCacheTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

import XCTest
@testable import MarvelProject

class ImageCacheTests: XCTestCase {
    private var sut: ImageCache!
    private let dataTest = Data(count: 1)
    private let urlTest = "urlTest"

    override func setUp() {
        super.setUp()
        sut = ImageCache.shared
    }

    override func tearDown() {
        sut.remove(url: urlTest)
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func testSave() {
		// Given
        XCTAssertNil(sut.get(url: urlTest))

        // When
        sut.save(url: urlTest, data: dataTest)

        // Then
        let result = sut.get(url: urlTest)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, dataTest)
    }

    func testGet() {
        // Given
        sut.save(url: urlTest, data: dataTest)

        // When
        let result = sut.get(url: urlTest)
        let resultNil = sut.get(url: "testNil")

        // Then
        XCTAssertNotNil(result)
        XCTAssertNil(resultNil)
    }

    func testRemove() {
        // Given
        sut.save(url: urlTest, data: dataTest)
        XCTAssertNotNil(sut.get(url: urlTest))

        // When
        sut.remove(url: urlTest)

        // Then
        XCTAssertNil(sut.get(url: urlTest))
    }
}
