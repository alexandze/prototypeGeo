//
//  ContainerFormCulturalPracticeAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ContainerFormCulturalPracticeAction {
    struct ContainerElementSelectedOnListAction: Action {
        var section: Section<ElementUIData>
        var field: Field
    }

    struct CheckIfFormIsDirtyAndValidAction: Action { }

    struct CheckIfInputValueIsValidAction: Action {
        var id: UUID
        var value: String
    }
    
    struct CloseContainerFormWithSaveAction: Action { }
    struct CloseContainerFormWithoutSaveAction: Action { }
}
