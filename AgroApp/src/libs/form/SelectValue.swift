//
//  SelectValue.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

protocol SelectValue: ValueForm {
    func getRawValue() -> Int
    static func getValues() -> [String]
    static func getTupleValues() -> [(Int, String)]
    static func make(rawValue: Int) -> SelectValue?
}
