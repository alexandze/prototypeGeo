//
//  CulturalPracticeFormAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct CulturalPracticeFormAction {
    struct SelectedElementOnList: Action {
        let culturalPracticeElement: CulturalPracticeElementProtocol
        let fieldType: FieldType
        let culturalPracticeFormSubAction: CulturalPracticeFormSubAction
    }
}
