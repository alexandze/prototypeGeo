//
//  ValueForm.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-07.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

protocol ValueForm {
    func getValue() -> String
    static func getTypeValue() -> String
    static func getTitle() -> String
}
