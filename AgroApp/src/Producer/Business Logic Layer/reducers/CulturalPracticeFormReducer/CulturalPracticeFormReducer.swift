//
//  CulturalPracticeFormReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func culturalPracticeFormReducer(action: Action, state: CulturalPracticeFormState?) -> CulturalPracticeFormState {
        let state = state ?? CulturalPracticeFormState(uuidState: UUID().uuidString)

        switch action {
        case let selectedFieldOnList as FieldListAction.SelectFieldOnListAction:
            return CulturalPracticeFormReducerHandler
                .HandlerSelectFieldOnListAction().handle(action: selectedFieldOnList, state)
        case let addDoseFumierAction as CulturalPracticeFormAction.AddDoseFumierAction:
            return CulturalPracticeFormReducerHandler
                .HandleAddDoseFumierAction().handle(action: addDoseFumierAction, state)
        case let updateCulturalPracticeElement as CulturalPracticeFormAction.UpdateCulturalPracticeElementAction:
            return CulturalPracticeFormReducerHandler
                .HandlerUpdateCulturalPracticeElementAction().handle(action: updateCulturalPracticeElement, state)
        case let selectElementOnList as CulturalPracticeFormAction.SelectElementOnListAction:
            return CulturalPracticeFormReducerHandler
                .HandlerSelectElementOnListAction().handle(action: selectElementOnList, state)
        case let removeDoseFumierAction as CulturalPracticeFormAction.RemoveDoseFumierAction:
            return CulturalPracticeFormReducerHandler
                .HandlerRemoveDoseFumierAction().handle(action: removeDoseFumierAction, state)
        case let showFieldDataSectionListAction as CulturalPracticeFormAction.ShowFieldDataSectionListAction:
            return CulturalPracticeFormReducerHandler
                .HandlerShowFieldDataSectionListAction().handle(action: showFieldDataSectionListAction, state)
        case let showCulturalPracticeDataSectionListAction as CulturalPracticeFormAction.ShowCulturalPracticeDataSectionListAction:
            return CulturalPracticeFormReducerHandler
                .HandlerShowCulturalPracticeDataSectionListAction().handle(action: showCulturalPracticeDataSectionListAction, state)
        case _ as ContainerMapAndTitleNavigationAction.KillStateAction:
            return state.reset()
        default:
            break
        }

        return state
    }
}

class CulturalPracticeFormReducerHandler { }
