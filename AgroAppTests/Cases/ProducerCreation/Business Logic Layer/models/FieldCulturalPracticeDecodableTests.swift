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

class FieldCulturalPracticeDecodableTests: XCTestCase {
    var sut: FieldCulturalPracticeDecodable!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut =  UtilReaderFile.readJsonFile(resource: "FieldCulturalPracticeDataTest", typeRessource: "json", FieldCulturalPracticeDecodable.self)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testfieldWrappers_fieldWrappersIsNotNitExample() throws {
        let fieldWrappers = self.sut.fieldWrappers
        XCTAssertNotNil(fieldWrappers)
    }
    
    func testGetFieldDictionnaryCount_countEqualTo208() throws {
        let count = sut.getFieldDictionnary().count
        XCTAssertEqual(count, 208)
    }
    
    func testField_notDoseFumier() throws {
        // A field with id 29 is not have dose fumier
        let field = sut.getFieldDictionnary()[29]
        let doseFumiers = field!.culturalPratice!.doseFumier!
        
        doseFumiers.forEach { doseFumier in
            XCTAssertNil(doseFumier)
        }
    }
    
    func testField_twoDoseFumierAndOtherValuesIsNil() throws {
        let fieldCulturalPracticeDecodable =  readFileData(nameFile: "FieldCulturalPracticeDataDoseFumierTest")

        let (doseFumiers, periodeApplicationFumiers, delaiIncorporationFumiers) =
            getDoseFumierTupe(fieldCulturalPracticeDecodable: fieldCulturalPracticeDecodable, id: 29)
        
        let countDoseFumier = doseFumiers!.count
        let valueDoseFumier = ["1", "2", "3"]
        
        (0..<countDoseFumier).forEach { index in
            XCTAssertEqual(doseFumiers![index]!.getValue(), valueDoseFumier[index])
            XCTAssertNil(periodeApplicationFumiers![index])
            XCTAssertNil(delaiIncorporationFumiers![index])
        }
    }
    
    func testField_doseFumierSkipValueFromFirstNil() {
        // in json data, I have first dose and third dose but not second dose,
        let fieldCulturalPracticeDecodable = readFileData(nameFile: "FieldCulturalPracticeDataDoseFumierTest")
        let (doseFumiers, periodeApplicationFumiers, delaiIncorporationFumiers) =
            getDoseFumierTupe(fieldCulturalPracticeDecodable: fieldCulturalPracticeDecodable, id: 30)
        let countDoseFumier = doseFumiers!.count
        
        (0..<countDoseFumier).forEach { index in
            if index == 0 {
                XCTAssertEqual(doseFumiers![index]!.getValue(), "1")
                XCTAssertEqual(periodeApplicationFumiers![index]!, .preSemi)
                XCTAssertEqual(delaiIncorporationFumiers![index]!, .nonIncorpore)
                return
            }
            
            XCTAssertNil(doseFumiers![index])
            XCTAssertNil(periodeApplicationFumiers![index])
            XCTAssertNil(delaiIncorporationFumiers![index])
        }
    }
    
    func testFieldDictionnary_skipFieldJsonDataWithNoId() throws {
        let fieldCulturalPracticeDecodable = readFileData(nameFile: "FieldCulturalPracticeDataDoseFumierTest")
        let fieldDictionnary = fieldCulturalPracticeDecodable!.getFieldDictionnary()
        
        XCTAssertEqual(fieldDictionnary.count, 2)
        XCTAssertNotNil(fieldDictionnary[29])
        XCTAssertNotNil(fieldDictionnary[30])
    }
    
    private func getDoseFumierTupe(fieldCulturalPracticeDecodable: FieldCulturalPracticeDecodable?, id: Int) ->
        ([DoseFumier?]?, [PeriodeApplicationFumier?]?, [DelaiIncorporationFumier?]?) {
            let field = fieldCulturalPracticeDecodable?.getFieldDictionnary()[id]
            let doseFumiers = field?.culturalPratice?.doseFumier
            let periodeApplicationFumier = field?.culturalPratice?.periodeApplicationFumier
            let delaiIncorporationFumier = field?.culturalPratice?.delaiIncorporationFumier
            return (doseFumiers, periodeApplicationFumier, delaiIncorporationFumier)
    }
    
    private func readFileData(nameFile: String) -> FieldCulturalPracticeDecodable? {
        UtilReaderFile
            .readJsonFile(
                resource: nameFile,
                typeRessource: "json",
                FieldCulturalPracticeDecodable.self
        )
    }
}
