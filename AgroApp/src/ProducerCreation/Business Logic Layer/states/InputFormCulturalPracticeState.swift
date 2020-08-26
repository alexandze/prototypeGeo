//
//  InputFormCulturalPracticeState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct InputFormCulturalPracticeState: Equatable {
    static func == (lhs: InputFormCulturalPracticeState, rhs: InputFormCulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var sectionInputElement: Section<ElementUIData>?
    var inputElementObservable: InputElementObservable?
    var field: Field?
    var isDirty: Bool?
    var actionResponse: InputFormCulturalPracticeActionResponse?
    
    enum InputFormCulturalPracticeActionResponse {
        case inputElementSelectedOnListActionResponse
        case closeInputFormWithSaveActionResponse
        case noAction
        case closeInputFormWithoutSaveActionResponse
        case checkIfInputValueIsValidActionResponse
        case checkIfFormIsValidAndDirtyForPrintAlertActionResponse(isPrintAlert: Bool)
    }

    func changeValue(
        sectionInputElement: Section<ElementUIData>? = nil,
        inputElementObservable: InputElementObservable? = nil,
        field: Field? = nil,
        isDirty: Bool? = nil,
        actionResponse: InputFormCulturalPracticeActionResponse? = nil
    ) -> InputFormCulturalPracticeState {
        InputFormCulturalPracticeState(
            uuidState: UUID().uuidString,
            sectionInputElement: sectionInputElement ?? self.sectionInputElement,
            inputElementObservable: inputElementObservable ?? self.inputElementObservable,
            field: field ?? self.field,
            isDirty: isDirty ?? self.isDirty,
            actionResponse: actionResponse ?? self.actionResponse
        )
    }
}


