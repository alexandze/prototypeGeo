//
//  ContainerFormCulturalPracticeReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func containerFormCulturalPracticeReducer(action: Action, state: ContainerFormCulturalPracticeState?) -> ContainerFormCulturalPracticeState {
        let state = state ?? ContainerFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let containerElementSelectedOnListAction as ContainerFormCulturalPracticeAction.ContainerElementSelectedOnListAction:
            return  ContainerFormCulturalPracticeHandler
                .HandlerContainerElementSelectedOnListAction().handle(action: containerElementSelectedOnListAction, state)
        case let checkIfInputValueIsValidAction as ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction:
            return ContainerFormCulturalPracticeHandler
                .HandlerCheckIfInputValueIsValidAction().handle(action: checkIfInputValueIsValidAction, state)
        case let closeContainerFormWithSaveAction as ContainerFormCulturalPracticeAction.CloseContainerFormWithSaveAction:
            return ContainerFormCulturalPracticeHandler
                .HandlerCloseContainerFormWithSaveAction().handle(action: closeContainerFormWithSaveAction, state)
        case let checkIfFormIsDirtyAndValidAction as ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction:
            return ContainerFormCulturalPracticeHandler
                .HandlerCheckIfFormIsDirtyAndValidAction().handle(action: checkIfFormIsDirtyAndValidAction, state)
        case let closeContainerFormWithoutSaveAction as ContainerFormCulturalPracticeAction.CloseContainerFormWithoutSaveAction:
            return ContainerFormCulturalPracticeHandler
                .HandlerCloseContainerFormWithoutSaveAction().handle(action: closeContainerFormWithoutSaveAction, state)
        case _ as ContainerMapAndTitleNavigationAction.KillStateAction:
            return state.reset()
        default:
            return state
        }
    }
}

class ContainerFormCulturalPracticeHandler { }
