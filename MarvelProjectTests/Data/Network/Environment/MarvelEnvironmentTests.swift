//
//  MarvelEnvironmentTests.swift
//  MarvelProjectTests
//
//  Created by Manuel Alvarez Marin on 23/5/22.
//

@testable import MarvelProject
import XCTest

class MarvelEnvironmentTests: XCTestCase{
    private var sut : MarvelEnvironment!
    
    override func setUp() {
        super.setUp()
        sut = MarvelEnvironment()
    }
    
    func testInit(){
        XCTAssertNotNil(sut)
    }
    
    func testProperties(){
        XCTAssertEqual(sut.baseURL, "https://gateway.marvel.com")
        XCTAssertEqual(sut.timeoutInterval, 10.0)
        XCTAssertEqual(sut.logMode, true)
        XCTAssertEqual(sut.serverTrust, true)
    }
}
