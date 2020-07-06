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
            XCTAssertTrue(type(of: element) != CulturalPracticeInputMultiSelectContainer.self)
        }
    }
    
    func createCulturalPractice() -> CulturalPractice {
        CulturalPractice(avaloir: .captagePartiel, bandeRiveraine: .inferieura1M, doseFumier: [], periodeApplicationFumier: [], delaiIncorporationFumier: [], travailSol: .labourAutomneTravailSecondairePrintemps, couvertureAssociee: .vrai, couvertureDerobee: .vrai, drainageSouterrain: .partiel, drainageSurface: .moyen, conditionProfilCultural: .dominanceZoneRisque, tauxApplicationPhosphoreRang: .taux(10.2), tauxApplicationPhosphoreVolee: .taux(22.25), pMehlich3: .taux(23.25), alMehlich3: .taux(145), cultureAnneeEnCoursAnterieure: .foi)
    }
}
