//
//  CulturalPractiqueUtil.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

enum UnitType {
    case kgHa
    case percentage
    case quantity

    func convertToString() -> String {
        switch self {
        case .kgHa:
            return "kg/ha"
        case .percentage:
            return "%"
        case .quantity:
            return "quantité"
        }
    }
}

typealias KilogramPerHectare = Double
typealias Percentage = Double

struct CulturalPracticeAddElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var value: CulturalPracticeValueProtocol?

    func getIndex() -> Int? {
        nil
    }
}

struct CulturalPracticeContainerElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var index: Int
    var culturalInputElement: [CulturalPracticeElementProtocol]
    var culturalPracticeMultiSelectElement: [CulturalPracticeElementProtocol]
    var value: CulturalPracticeValueProtocol?

    func getIndex() -> Int? {
        index
    }

    func hasAllValueCompleted() -> Bool {
        culturalInputElement.firstIndex { $0.value == nil } == nil &&
        culturalPracticeMultiSelectElement.firstIndex { $0.value == nil } == nil
    }
}

struct CulturalPracticeMultiSelectElement: CulturalPracticeElementProtocol {
    let key: String
    var title: String
    var tupleCulturalTypeValue: [(CulturalPracticeValueProtocol, String)]
    var value: CulturalPracticeValueProtocol?
    var index: Int?

    func getIndex() -> Int? {
        index
    }
}

struct CulturalPracticeInputElement: CulturalPracticeElementProtocol {
    let key: String
    let title: String
    var valueEmpty: CulturalPracticeValueProtocol
    var value: CulturalPracticeValueProtocol?
    var index: Int?

    func getIndex() -> Int? {
        index
    }
}

protocol CulturalPracticeValueProtocol {
    static func getTitle() -> String
    func getValue() -> String
    static func getValues() -> [(CulturalPracticeValueProtocol, String)]?
    func getUnitType() -> UnitType?
    static func create(value: String) -> CulturalPracticeValueProtocol?
    static func getRegularExpression() -> String?
    func changeValueOfCulturalPractice(_ culturalPractice: CulturalPractice, index: Int?) -> CulturalPractice
}

extension CulturalPracticeElementProtocol {
    func getValueBy(indexSelected: Int, from values: [(CulturalPracticeValueProtocol, String)]) -> CulturalPracticeValueProtocol? {
        guard values.indices.contains(indexSelected) else { return nil }
        return values[indexSelected].0
    }

    func getValueBy(
        inputValue: String,
        from emptyValue: CulturalPracticeValueProtocol
    ) -> CulturalPracticeValueProtocol? {
        return type(of: emptyValue).create(value: inputValue)
    }
}

protocol CulturalPracticeElementProtocol {
    var title: String {get}
    var key: String {get}
    var value: CulturalPracticeValueProtocol? {get}
    func getIndex() -> Int?
}
