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
        var field: Field
        var subAction:  ContainerFormCulturalPracticeState.SubAction = .containerElementSelectedOnListActionSuccess
    }

    struct CheckIfFormIsDirtyAndValidAction: Action {
        var inputValues: [String]
        var selectValue: [Int]
    }

    struct CheckIfInputValueIsValidAction: Action {
        var inputValues: [String]
    }

    struct CheckIfFormIsValidAction: Action {
        var inputValues: [String]
        var selectValue: [Int]
    }

    struct UpdateContainerElementAction: Action {
        var inputValues: [String]
        var selectValues: [Int]
    }
}
