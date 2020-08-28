//
//  ContainerFormCulturalPracticeInteraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ContainerFormCulturalPracticeInteractionImpl: ContainerFormCulturalPracticeInteraction {
    
    let actionDispatcher: ActionDispatcher
    
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    
    func checkIfInputValueIsValidAction(_ id: UUID, value: String) {
        Util.dispatchActionInSchedulerReSwift(
            ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction(id: id, value: value),
            actionDispatcher: actionDispatcher
        )
    }
    
    func closeContainerFormWithSaveAction() {
        Util.dispatchActionInSchedulerReSwift(
            ContainerFormCulturalPracticeAction.CloseContainerFormWithSaveAction(),
            actionDispatcher: actionDispatcher
        )
    }
    
    func updateCulturalPracticeElementAction(section: Section<ElementUIData>, field: Field) {
        Util.dispatchActionInSchedulerReSwift(
            CulturalPracticeFormAction.UpdateCulturalPracticeElementAction(section: section, field: field),
            actionDispatcher: actionDispatcher
        )
    }
    
    func checkIfFormIsDirtyAndValidAction() {
        Util.dispatchActionInSchedulerReSwift(
            ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction(),
            actionDispatcher: actionDispatcher
        )
    }
    
    func closeContainerFormWithoutSaveAction() {
        Util.dispatchActionInSchedulerReSwift(
            ContainerFormCulturalPracticeAction.CloseContainerFormWithoutSaveAction(),
            actionDispatcher: actionDispatcher
        )
    }
}

protocol ContainerFormCulturalPracticeInteraction {
    func checkIfInputValueIsValidAction(_ id: UUID, value: String)
    func closeContainerFormWithSaveAction()
    func updateCulturalPracticeElementAction(section: Section<ElementUIData>, field: Field)
    func checkIfFormIsDirtyAndValidAction()
    func closeContainerFormWithoutSaveAction()
}
