//
//  AddProducerFormFactoryTests.swift
//  AgroAppTests
//
//  Created by Alexandre Andze Kande on 2020-08-11.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import XCTest
@testable import AgroApp

class AddProducerFormFactoryTests: XCTestCase {
    var sut: AddProducerFormFactory!
    override func setUpWithError() throws {
        self.sut = AddProducerFormFactoryImpl()
    }

    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testFactory_WhenMakeElementsUIData_arrayCountEqualToFive() {
        let elementsUIData = sut.makeElementsUIData()
        let countElement = elementsUIData.count
        XCTAssertEqual(countElement, 5)
    }

}
