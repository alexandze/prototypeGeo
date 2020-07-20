//
//  CulturalPracticeTests.swift
//  AgroAppTests
//
//  Created by Alexandre Andze Kande on 2020-07-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import XCTest
@testable import AgroApp

class CulturalPracticeTests: XCTestCase {
    var sut: CulturalPractice!
    
    override func setUpWithError() throws {
        sut = createCulturalPractice()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testInit_CreateCulturalPractice() {
        XCTAssertNotNil(createCulturalPractice())
    }
    
    func testGetCulturalPracticeElement_arrayOfCulturalPracticeElementWithoutDynamicElement() {
        let elements = CulturalPractice.getCulturalPracticeElement(culturalPractice: sut)
        
        elements.forEach { element in
            XCTAssertTrue(type(of: element) != CulturalPracticeContainerElement.self)
        }
    }
    
    func testGetCulturalPracticeElement_arrayOfElementContentOneContainerElementWithDoseFumier() {
        let dose = 10
        self.sut.doseFumier?[0] = .dose(quantite: dose)
        let elements = CulturalPractice.getCulturalPracticeElement(culturalPractice: self.sut)
        let indexDoseFumier = elements.firstIndex { element in type(of: element) == CulturalPracticeContainerElement.self}
        
        let containerElement = elements[indexDoseFumier!] as! CulturalPracticeContainerElement
        let valueDose = containerElement.culturalInputElement[0].value!.getValue()
        XCTAssertEqual(valueDose, String(dose))
    }
    
    func testGetCulturalPracticeElement_arrayOfElementContentTwoContainerElement() {
        let dose1: DoseFumier = .dose(quantite: 10)
        let dose2: DoseFumier = .dose(quantite: 20)
        let periodeApplicationFumier1: PeriodeApplicationFumier = .automneHatif
        let delaiIncorporationFumier1: DelaiIncorporationFumier = .incorporeEn48H
        let delaiIncorporationFumier3: DelaiIncorporationFumier = .nonIncorpore
        sut.doseFumier?[0] = dose1
        sut.doseFumier?[1] = dose2
        sut.periodeApplicationFumier?[0] = periodeApplicationFumier1
        sut.delaiIncorporationFumier?[0] = delaiIncorporationFumier1
        sut.delaiIncorporationFumier?[2] = delaiIncorporationFumier3
        
        
        let elements = CulturalPractice.getCulturalPracticeElement(culturalPractice: sut)
        let elementContainers = elements.filter { element in type(of: element) == CulturalPracticeContainerElement.self}
        let countElementCounter = elementContainers.count
        let doseFromData1 = (elementContainers[0] as! CulturalPracticeContainerElement)
            .culturalInputElement[0].value!.getValue()
        
        let doseFromData2 = (elementContainers[1] as! CulturalPracticeContainerElement)
        .culturalInputElement[0].value!.getValue()
        
        let periodeApplicationFumierFromData1 = (elementContainers[0] as! CulturalPracticeContainerElement)
            .culturalPracticeMultiSelectElement[0].value!.getValue()
        
        let delaiIncorporationFumierFromData1 = (elementContainers[0] as! CulturalPracticeContainerElement)
        .culturalPracticeMultiSelectElement[1].value!.getValue()
        
        let delaiIncorporationFumierFromData3 = (elementContainers[2] as! CulturalPracticeContainerElement)
            .culturalPracticeMultiSelectElement[1].value!.getValue()
        
        XCTAssertEqual(countElementCounter, 3)
        XCTAssertEqual(doseFromData1, dose1.getValue())
        XCTAssertEqual(doseFromData2, dose2.getValue())
        XCTAssertEqual(periodeApplicationFumierFromData1, periodeApplicationFumier1.getValue())
        XCTAssertEqual(delaiIncorporationFumierFromData1, delaiIncorporationFumier1.getValue())
        XCTAssertEqual(delaiIncorporationFumierFromData3, delaiIncorporationFumier3.getValue())
    }
    
    func createCulturalPractice() -> CulturalPractice {
        CulturalPractice()
    }
}
