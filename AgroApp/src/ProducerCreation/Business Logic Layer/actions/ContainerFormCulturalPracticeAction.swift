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
        var containerElement: CulturalPracticeContainerElement
        var field: FieldType
        var subAction:  ContainerFormCulturalPracticeState.SubAction = .newFormData
    }

    struct CheckIfFormIsDirtyAndValidAction: Action {
        var inputValues: [String]
        var selectValue: [Int]
    }
}
