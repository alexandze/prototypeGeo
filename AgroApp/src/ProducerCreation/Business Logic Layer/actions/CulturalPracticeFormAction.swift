//
//  CulturalPracticeAction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct CulturalPracticeFormAction {

    struct AddDoseFumierAction: Action {}

    struct UpdateCulturalPracticeElementAction: Action {
        let section: Section<ElementUIData>
        let field: Field
    }

    struct SelectElementOnListAction: Action {
        let indexPath: IndexPath
    }

    struct RemoveDoseFumierAction: Action {
        let indexPath: IndexPath
    }
    
    struct ShowFieldDataSectionListAction: Action { }
    struct ShowCulturalPracticeDataSectionListAction: Action { }
}
