//
//  CulturalPracticeState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
struct CulturalPracticeState: Equatable {
    static func == (lhs: CulturalPracticeState, rhs: CulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var culturalPracticeSubState: TableState?
}
