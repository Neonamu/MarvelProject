//
//  MarvelAuthHelper.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

import XCTest
@testable import MarvelProject


class MarvelAuthHelperTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testCredentials() {
        // Given
        let publicKey = "testPK"
        let privateKey = "testPrivateKey"
        let ts = String(Date().timeIntervalSince1970)

        // When
        let marvelAuth = MarvelAuthHelper.generateCredentials(publicKey: publicKey, privateKey: privateKey, ts: ts)
        let hash = "\(ts)\(privateKey)\(publicKey)".md5

        // Then
        XCTAssertEqual(marvelAuth.hash, hash)
        XCTAssertEqual(marvelAuth.ts, ts)
        XCTAssertEqual(marvelAuth.apikey, publicKey)
    }
}
