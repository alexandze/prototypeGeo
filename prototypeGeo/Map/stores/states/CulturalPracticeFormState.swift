//
//  CulturalPracticeFormState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
struct CulturalPracticeFormState: Equatable {
    static func == (lhs: CulturalPracticeFormState, rhs: CulturalPracticeFormState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }
    
    var uuidState: String
    var culturalPraticeElement: CulturalPracticeElement?
    var fieldType: FieldType?
    var culturalPracticeSubAction: CulturalPracticeFormSubAction?
}

enum CulturalPracticeFormSubAction {
    case newDataForm
    case printAlert
}
