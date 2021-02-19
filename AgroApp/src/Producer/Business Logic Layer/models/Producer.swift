//
//  Producer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-15.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct Producer {
    var uuid = UUID()
    var firstName: FirstNameInputValue?
    var lastName: LastNameInputValue?
    var email: EmailInputValue?
    var enterprises: [Enterprise] = []
}
