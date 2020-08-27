//
//  ContainerFormCulturalPracticeState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ContainerFormCulturalPracticeState: Equatable {
    static func == (lhs: ContainerFormCulturalPracticeState, rhs: ContainerFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var field: Field?
    var section: Section<ElementUIData>?
    var elementUIDataObservableList: [ElementUIDataObservable]?
    var isFormValid: Bool?
    var actionResponse: ActionResponse?

    enum ActionResponse {
        case containerElementSelectedOnListActionSuccess
        case checkIfFormIsDirtyActionSuccess
        case checkIfInputValueIsValidActionSuccess
        case updateContainerElementActionSuccess
    }

    func changeValue(
        
    ) -> ContainerFormCulturalPracticeState {
        
    }
}
