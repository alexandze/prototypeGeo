//
//  SelectFormCulturalPracticeReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func selectFormCulturalPracticeReducer(action: Action, state: SelectFormCulturalPracticeState?) -> SelectFormCulturalPracticeState {
        let state = state ?? SelectFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let selectedElementOnListAction as SelectFormCulturalPracticeAction.SelectElementSelectedOnListAction:
            return SelectFormCulturalPracticeHandlerReducer
                .HandlerSelectElementSelectedOnListAction().handle(action: selectedElementOnListAction, state)
        case let closeSelectFormWithSaveAction as SelectFormCulturalPracticeAction.CloseSelectFormWithSaveAction:
            return SelectFormCulturalPracticeHandlerReducer
                .HandlerCloseSelectFormWithSaveAction().handle(action: closeSelectFormWithSaveAction, state)
        case let closeSelectFormWithoutSaveAction as SelectFormCulturalPracticeAction.CloseSelectFormWithoutSaveAction:
            return SelectFormCulturalPracticeHandlerReducer
                .HandlerCloseSelectFormWithoutSaveAction().handle(action: closeSelectFormWithoutSaveAction, state)
        case let checkIfFormIsDirtyAction as SelectFormCulturalPracticeAction.CheckIfFormIsDirtyAction:
            return SelectFormCulturalPracticeHandlerReducer
                .HandlerCheckIfFormIsDirtyAction().handle(action: checkIfFormIsDirtyAction, state)
        case _ as ContainerMapAndTitleNavigationAction.KillStateAction:
            return state.reset()
        default:
            return state
        }
    }
}

class SelectFormCulturalPracticeHandlerReducer { }
