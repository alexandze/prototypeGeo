//
//  prototypeGeoTests.swift
//  prototypeGeoTests
//
//  Created by Alexandre Andze Kande on 2020-04-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import XCTest
import prototypeGeo

class prototypeGeoTests: XCTestCase {
    var appDep: AppDependencyContainer?
    override func setUp() {
        
        self.appDep = AppDependencyContainerImpl()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let vm =  self.appDep?.processInitCulturalPracticeViewController()
        XCTAssertNotNil(vm, "vm is not nul")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
