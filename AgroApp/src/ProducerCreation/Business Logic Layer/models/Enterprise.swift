//
//  Enterprise.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct Enterprise {
    static var MAX_ENTERPRISE = 5
    var nim: NimInputValue?
    var fields = [Field]()
}

struct NimInputValue: InputValue {
    var value: String
    
    static func getRegexPattern() -> String {
        "^[A-Z0-9]{2,}$"
    }
    
    static func getUnitType() -> String {
        ""
    }
    
    static func make(value: String) -> InputValue? {
        NimInputValue(value: value)
    }
    
    func getValue() -> String {
        value
    }
    
    static func getTypeValue() -> String {
        "nim"
    }
    
    static func getTitle() -> String {
        "NIM"
    }
}

struct NimSelectValue: SelectValueInit {
    
    var values: [String]
    var indexValueSelected: Int?
    
    func getIndexValueSelected() -> Int? {
        indexValueSelected
    }
    
    func getValues() -> [String] {
        values
    }
    
    func getTupleValues() -> [(Int, String)] {
        (0..<values.count).map { index in
            (index, values[index])
        }
    }
    
    static func make(_ values: [String], _ indexValueSelected: Int?) -> SelectValueInit {
        NimSelectValue(values: values, indexValueSelected: values.count == 1 ? 0 : indexValueSelected)
    }
    
    static func setIndexValueSelected(_ indexValueSelected: Int, selectValueInit: SelectValueInit) -> SelectValueInit {
        guard var nimSelectValue = selectValueInit as? NimSelectValue else {
            return selectValueInit
        }
        
        nimSelectValue.indexValueSelected = indexValueSelected
        return nimSelectValue
    }
    
    func getValue() -> String {
        if values.count == 1 {
            return values[0]
        }
        
        if let index = indexValueSelected {
            return values[index]
        }
        
        return ""
    }
    
    static func getTypeValue() -> String {
        "nim"
    }
    
    static func getTitle() -> String {
        "NIM"
    }
    
}
