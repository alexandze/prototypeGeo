//
//  CulturalPraticeFormInteraction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class CulturalPraticeFormInteractionImpl: CulturalPraticeFormInteraction {

    let actionDispatcher: ActionDispatcher

    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    func setCurrentViewControllerInNavigationAction() {
        let action = ContainerTitleNavigationAction
            .SetCurrentViewControllerAction(currentViewControllerInNavigation: .culturalPracticeForm)
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    /// action for set title of TitleNavigationViewController
    func setTitleAction(title: String) {
        let action = ContainerTitleNavigationAction.SetTitleAction(title: title)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    func selectedSelectElementOnListActionObs(
        section: Section<ElementUIData>,
        field: Field
    ) -> Completable {
        Util.createRunCompletable {
            let action = SelectFormCulturalPracticeAction
                .SelectElementSelectedOnListAction(section: section, field: field)

            self.actionDispatcher.dispatch(action)
        }
    }

    func selectedInputElementOnListActionObs(
        section: Section<ElementUIData>,
        field: Field
    ) -> Completable {
        Util.createRunCompletable {
            let action = InputFormCulturalPracticeAction
                .InputElementSelectedOnListAction(sectionInputElement: section, field: field)

            self.actionDispatcher.dispatch(action)
        }
    }

    func addDoseFumierAction() {
        Util.dispatchActionInSchedulerReSwift(CulturalPracticeFormAction.AddDoseFumierAction(), actionDispatcher: actionDispatcher)
    }

    func selectElementOnListAction(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.SelectElementOnListAction(indexPath: indexPath)
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }

    func removeDoseFumierAction(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.RemoveDoseFumierAction(indexPath: indexPath)
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }

    func updateFieldAction(field: Field) {
        let action = FieldListAction.UpdateFieldAction(field: field)
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }

    func selectedContainerElementObs(section: Section<ElementUIData>, field: Field) -> Completable {
        Util.createRunCompletable {
            let action = ContainerFormCulturalPracticeAction.ContainerElementSelectedOnListAction(section: section, field: field)
            self.actionDispatcher.dispatch(action)
        }
    }
}

protocol CulturalPraticeFormInteraction {
    func setCurrentViewControllerInNavigationAction()
    func addDoseFumierAction()
    func selectElementOnListAction(indexPath: IndexPath)

    func selectedInputElementOnListActionObs(
        section: Section<ElementUIData>,
        field: Field
    ) -> Completable

    func selectedContainerElementObs(
        section: Section<ElementUIData>,
        field: Field
    ) -> Completable

    func selectedSelectElementOnListActionObs(
        section: Section<ElementUIData>,
        field: Field
    ) -> Completable

    func setTitleAction(title: String)
    func removeDoseFumierAction(indexPath: IndexPath)
    func updateFieldAction(field: Field)
}
