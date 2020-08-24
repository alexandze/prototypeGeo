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

    func dispatchSetCurrentViewControllerInNavigationAction() {
        let action = ContainerTitleNavigationAction
            .SetCurrentViewControllerAction(currentViewControllerInNavigation: .fieldList)
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    /// action for set title of TitleNavigationViewController
    func dispatchSetTitleAction(title: String?) {
        let action = ContainerTitleNavigationAction.SetTitleAction(title: title ?? "")

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchSelectedSelectElementOnListObs(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        field: Field
    ) -> Completable {
        Util.createRunCompletable {
            let action = self.createSelectedSelectElementOnListAction(
                culturalPracticeSelectElement: culturalPracticeElement,
                field: field
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchSelectedInputElementOnListObs(
        inputElement: CulturalPracticeInputElement,
        field: Field
    ) -> Completable {
        Util.createRunCompletable {
            let action = self.createSelectedInputElementOnListAction(
                inputElement: inputElement,
                field: field
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchSelectedContainerElementOnListObs(
        containerElement: CulturalPracticeContainerElement,
        field: Field
    ) -> Completable {
        Util.createRunCompletable {
            let action = ContainerFormCulturalPracticeAction
                .ContainerElementSelectedOnListAction(
                    containerElement: containerElement,
                    field: field
            )

            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchAddDoseFumier() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.AddDoseFumierAction()
            )
        }
    }

    func dispathWillSelectElementOnList(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.SelectElementOnListAction(indexPath: indexPath)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchRemoveDoseFumierAction(indexPath: IndexPath) {
        let action = CulturalPracticeFormAction.RemoveDoseFumierAction(indexPath: indexPath)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    func dispatchUpdateFieldAction(field: Field?) {
        guard let field = field else { return }
        let action = FieldListAction.UpdateFieldAction(field: field)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func createSelectedSelectElementOnListAction(
        culturalPracticeSelectElement: CulturalPracticeElementProtocol,
        field: Field
    ) -> SelectFormCulturalPracticeAction.SelectElementSelectedOnList {
        SelectFormCulturalPracticeAction.SelectElementSelectedOnList(
            culturalPracticeElement: culturalPracticeSelectElement,
            field: field,
            subAction: SelectFormCulturalPracticeSubAction.newDataForm
        )
    }

    private func createSelectedInputElementOnListAction(
        inputElement: CulturalPracticeInputElement,
        field: Field
    ) -> InputFormCulturalPracticeAction.InputElementSelectedOnListAction {
        InputFormCulturalPracticeAction.InputElementSelectedOnListAction(
            culturalPracticeInputElement: inputElement,
            field: field,
            subAction: .newFormData)
    }
}

protocol CulturalPraticeFormInteraction {
    func dispatchSetCurrentViewControllerInNavigationAction()
    func dispathWillSelectElementOnList(indexPath: IndexPath)
    func dispatchAddDoseFumier()

    func dispatchSelectedContainerElementOnListObs(
        containerElement: CulturalPracticeContainerElement,
        field: Field
    ) -> Completable

    func dispatchSelectedInputElementOnListObs(
        inputElement: CulturalPracticeInputElement,
        field: Field
    ) -> Completable

    func dispatchSelectedSelectElementOnListObs(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        field: Field
    ) -> Completable

    func dispatchSetTitleAction(title: String?)
    func dispatchRemoveDoseFumierAction(indexPath: IndexPath)
    func dispatchUpdateFieldAction(field: Field?)
}
