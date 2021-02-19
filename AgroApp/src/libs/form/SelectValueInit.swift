//
//  SelectValueInit.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

protocol SelectValueInit: ValueForm {
    func getIndexValueSelected() -> Int?
    func getValues() -> [String]
    func getTupleValues() -> [(Int, String)]
    static func make(_ values: [String], _ indexValueSelected: Int?) -> SelectValueInit
    static func setIndexValueSelected(_ indexValueSelected: Int, selectValueInit: SelectValueInit) -> SelectValueInit
}
