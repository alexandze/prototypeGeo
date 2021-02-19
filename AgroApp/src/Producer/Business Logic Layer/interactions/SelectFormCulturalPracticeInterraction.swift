//
//  SelectFormCulturalPracticeInterraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class SelectFormCulturalPracticeInterractionImpl: SelectFormCulturalPracticeInterraction {
    let actionDispatcher: ActionDispatcher

    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    func closeSelectFormWithSaveAction(indexSelected: Int) {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                SelectFormCulturalPracticeAction.CloseSelectFormWithSaveAction(indexSelected: indexSelected)
            )
        }
    }

    func updateCulturalPracticeElementAction(_ section: Section<ElementUIData>,_ field: Field) {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                CulturalPracticeFormAction.UpdateCulturalPracticeElementAction(section: section, field: field)
            )
        }
    }

    func closeSelectFormWithoutSaveAction() {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                SelectFormCulturalPracticeAction.CloseSelectFormWithoutSaveAction()
            )
        }
    }

    func checkIfFormIsDirtyAction(_ indexSelected: Int) {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                SelectFormCulturalPracticeAction.CheckIfFormIsDirtyAction(indexSelected: indexSelected)
            )
        }
    }
}

protocol SelectFormCulturalPracticeInterraction {
    func closeSelectFormWithSaveAction(indexSelected: Int)
    func updateCulturalPracticeElementAction(_ section: Section<ElementUIData>,_ field: Field)
    func closeSelectFormWithoutSaveAction()
    func checkIfFormIsDirtyAction(_ indexSelected: Int)

}
