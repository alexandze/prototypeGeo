//
//  AgroAppTests.swift
//  AgroAppTests
//
//  Created by Alexandre Andze Kande on 2020-06-30.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import XCTest
@testable import AgroApp

class AgroAppTests: XCTestCase {
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let test = Int(10.99)
        XCTAssertEqual(test, 10)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
