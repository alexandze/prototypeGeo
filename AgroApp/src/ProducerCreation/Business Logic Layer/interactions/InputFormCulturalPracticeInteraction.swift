//
//  InputFormCulturalPracticeInteraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class InputFormCulturalPracticeInteractionImpl: InputFormCulturalPracticeInteraction {
    let actionDispatcher: ActionDispatcher
    
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    func closeInputFormWithSaveAction(inputValue: String) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                InputFormCulturalPracticeAction.CloseInputFormWithSaveAction(inputValue: inputValue)
            )
        }
    }
    
    func updateCulturalPracticeElementAction(_ sectionUpdate: Section<ElementUIData>, _ field: Field) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.UpdateCulturalPracticeElementAction(section: sectionUpdate, field: field)
            )
        }
    }
    
    func closeInputFormWithoutSaveAction() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction()
            )
        }
    }
    
    func checkIfInputValueIsValidAction(_ inputValue: String) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                InputFormCulturalPracticeAction.CheckIfInputValueIsValidAction(inputValue: inputValue)
            )
        }
    }
    
    func checkIfFormIsValidAndDirtyForPrintAlertAction() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                InputFormCulturalPracticeAction.CheckIfFormIsValidAndDirtyForPrintAlertAction()
            )
        }
    }
}


protocol InputFormCulturalPracticeInteraction {
    func closeInputFormWithSaveAction(inputValue: String)
    func updateCulturalPracticeElementAction(_ sectionUpdate: Section<ElementUIData>, _ field: Field)
    func closeInputFormWithoutSaveAction()
    func checkIfInputValueIsValidAction(_ inputValue: String)
    func checkIfFormIsValidAndDirtyForPrintAlertAction()
}
