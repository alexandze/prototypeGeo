//
//  IdPleinTerre.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-24.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct IdPleineTerre: CulturalPracticeValueProtocol {
    var idPlein: String
    
    static func getTitle() -> String {
        "ID Pleine Terre"
    }
    
    func getValue() -> String {
        idPlein
    }
    
    static func getValues() -> [(CulturalPracticeValueProtocol, String)]? {
        nil
    }
    
    func getUnitType() -> UnitType? {
        nil
    }
    
    static func create(value: String) -> CulturalPracticeValueProtocol? {
        IdPleineTerre(idPlein: value)
    }
    
    static func getRegularExpression() -> String? {
        "^[A-Z0-9]{2,}$"
    }
    
    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice {
        var newCulturalPracticeValue = culturalPractice
        newCulturalPracticeValue.idPleinTerre = self
        return newCulturalPracticeValue
    }
    
    static func getCulturalPracticeElement(field: Field?) -> CulturalPracticeElementProtocol {
        CulturalPracticeInputElement(
            key: UUID().uuidString,
            title: getTitle(),
            valueEmpty: IdPleineTerre(idPlein: ""),
            value: field?.idPleinTerre
        )
    }
}
