//
//  FieldGeoJsonArrayTests.swift
//  AgroAppTests
//
//  Created by Alexandre Andze Kande on 2020-07-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import XCTest
import Foundation
@testable import AgroApp

class FieldGeoJsonArrayTests: XCTestCase {
    var sut: FieldGeoJsonArray1!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
       sut =  UtilReaderFile.readJsonFile(resource: "ACTU", typeRessource: "json", FieldGeoJsonArray1.self)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testExample() throws {
        let culturalPractice = self.sut.features[0].geometry
        XCTAssertNotNil(culturalPractice)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
