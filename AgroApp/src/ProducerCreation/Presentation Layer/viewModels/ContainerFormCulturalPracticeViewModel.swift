//
//  ContainerFormCulturalPracticeViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-10.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI
import Combine
import ReSwift

class ContainerFormCulturalPracticeViewModelImpl: ContainerFormCulturalPracticeViewModel {
    let viewState: ViewState
    var view: ContainerElementView?
    private let stateObserver: Observable<ContainerFormCulturalPracticeState>
    private let actionDispatcher: ActionDispatcher
    private var disposableStateObserver: Disposable?
    private var state: ContainerFormCulturalPracticeState?
    private var disposeDispatcher: Disposable?
    private var inputValuesAnyCancellable: AnyCancellable?

    init(
        stateObserver: Observable<ContainerFormCulturalPracticeState>,
        viewState: ViewState,
        actionDispatcher: ActionDispatcher
    ) {
        self.stateObserver = stateObserver
        self.actionDispatcher = actionDispatcher
        self.viewState = viewState
    }

    func subscribeToStateObserver() {
        disposableStateObserver = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let state = event.element,
                    state.containerElement != nil && state.fieldType != nil &&
                        state.inputElements != nil && state.inputValues != nil &&
                        state.selectElements != nil && state.selectValues != nil &&
                        state.subAction != nil
                    else { return }

                self.setValue(state: state)

                switch state.subAction! {
                case .containerElementSelectedOnListActionSuccess:
                    self.handleContainerElementSelectedOnListActionSuccess()
                case .checkIfFormIsDirtyActionSuccess:
                    self.handleCheckIfFormIsDirtyActionSuccess()
                case .checkIfInputValueIsValidActionSuccess:
                    self.handleCheckIfInputValueIsValidActionSuccess()
                case .updateContainerElementActionSuccess:
                    self.handleUpdateContainerElementActionSuccess()
                }
        }
    }

    func subscribeToChangeInputValue() {
        self.inputValuesAnyCancellable = self.viewState.$inputValues.sink(
            receiveValue: handleChangeInputValues(inputValues: )
        )
    }

    func disposeObserver() {
        disposableStateObserver?.dispose()
        self.inputValuesAnyCancellable?.cancel()
    }

    private func setViewStateValue() {
        viewState.titleForm = state!.containerElement!.title
        viewState.inputElements = state!.inputElements!
        viewState.selectElements = state!.selectElements!
        viewState.inputValues = state!.inputValues!
        viewState.selectValue = state!.selectValues!
        viewState.isPrintMessageErrorInputValues = state!.isPrintMessageErrorInputValues!
        viewState.isFormValid = state!.isFormValid!
    }

    private func setValue(
        state: ContainerFormCulturalPracticeState
    ) {
        self.state = state
    }

    private func createCheckIfFormIsDirtyAction()
        -> ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction {
        ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction(
            inputValues: viewState.inputValues,
            selectValue: viewState.selectValue
        )
    }

    private func printAlert() {
        viewState.presentAlert = true
    }

    private func isDirtyAndIsFormValid() -> Bool {
        state!.isDirty! && state!.isFormValid!
    }

    private func createCheckIfInputValueIsValidAction(
        inputValues: [String]
    ) -> ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction {
        ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction(
            inputValues: inputValues
        )
    }

    private func setViewStateForCheckIfInputValueIsValidActionSuccess() {
        viewState.isPrintMessageErrorInputValues = state!.isPrintMessageErrorInputValues!
        viewState.isFormValid = state!.isFormValid!
    }

    private func createUpdateContainerElementAction()
        -> ContainerFormCulturalPracticeAction.UpdateContainerElementAction {
        ContainerFormCulturalPracticeAction.UpdateContainerElementAction(
            inputValues: viewState.inputValues,
            selectValues: viewState.selectValue
        )
    }

    private func createUpdateCulturalPracticeElementAction() -> CulturalPracticeFormAction.UpdateCulturalPracticeElementAction {
        CulturalPracticeFormAction.UpdateCulturalPracticeElementAction(
            culturalPracticeElementProtocol: state!.containerElement!
        )
    }

    private func dismissForm () {
        viewState.isDismissForm = true
    }

    class ViewState: ObservableObject {
        @Published var titleForm: String = ""
        @Published var inputElements: [CulturalPracticeInputElement] = []
        @Published var selectElements: [CulturalPracticeMultiSelectElement] = []
        @Published var inputValues: [String] = []
        @Published var selectValue: [Int] = []
        @Published var isFormValid: Bool = false
        @Published var presentAlert: Bool = false
        @Published var textAlert: String = "Voulez-vous enregistrer les valeurs saisies ?"
        @Published var textButtonValidate: String = "Valider"
        @Published var textErrorMessage: String = "Veuillez saisir une valeur valide"
        @Published var isPrintMessageErrorInputValues: [Bool] = []
        @Published var isDismissForm: Bool = false
    }
}

// handler
extension ContainerFormCulturalPracticeViewModelImpl {

    func handleButtonValidate() {
        dispatchUpdateContainerElementAction(
            updateContainerElementAction: createUpdateContainerElementAction()
        )
    }

    func handleButtonClose() {
        dispatchCheckIfFormIsDirtyAction(checkIfFormIsDirtyAction: createCheckIfFormIsDirtyAction())
    }

    func handleAlertYesButton() {
        // TODO dispatch update form
    }

    func handleAlertNoButton() {
        // TODO dispatch close, no save
    }

    private func handleChangeInputValues(inputValues: [String]) {
        dispatchCheckIfInputValueIsValidAction(
            checkIfInputValueIsValidAction: createCheckIfInputValueIsValidAction(inputValues: inputValues)
        )
    }

    private func handleContainerElementSelectedOnListActionSuccess() {
        setViewStateValue()
    }

    private func handleCheckIfFormIsDirtyActionSuccess() {
        if isDirtyAndIsFormValid() {
            printAlert()
        }

        print(isDirtyAndIsFormValid() ? "printAlert" : "not print Alert")
    }

    private func handleCheckIfInputValueIsValidActionSuccess() {
        setViewStateForCheckIfInputValueIsValidActionSuccess()
    }

    private func handleUpdateContainerElementActionSuccess() {
        dispatchUpdateCulturalPracticeElementAction(
            updateCulturalPracticeElementAction: createUpdateCulturalPracticeElementAction()
        )

        dismissForm()
    }
}

// Dispatcher
extension ContainerFormCulturalPracticeViewModelImpl {
    private func dispatchCheckIfFormIsDirtyAction(
        checkIfFormIsDirtyAction: ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction
    ) {
        dispachAction(action: checkIfFormIsDirtyAction)
    }

    private func dispatchCheckIfInputValueIsValidAction(
        checkIfInputValueIsValidAction: ContainerFormCulturalPracticeAction.CheckIfInputValueIsValidAction
    ) {
        dispachAction(action: checkIfInputValueIsValidAction)
    }

    private func dispatchUpdateContainerElementAction(
        updateContainerElementAction: ContainerFormCulturalPracticeAction.UpdateContainerElementAction
    ) {
        dispachAction(action: updateContainerElementAction)
    }

    private func dispatchUpdateCulturalPracticeElementAction(
        updateCulturalPracticeElementAction: CulturalPracticeFormAction.UpdateCulturalPracticeElementAction
    ) {
        dispachAction(action: updateCulturalPracticeElementAction)
    }

    private func dispachAction(action: Action) {
        disposeDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }
}

protocol ContainerFormCulturalPracticeViewModel {
    var viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState {get}
    func subscribeToStateObserver()
    func disposeObserver()
    func handleButtonValidate()
    func handleButtonClose()
    func handleAlertYesButton()
    func handleAlertNoButton()
    func subscribeToChangeInputValue()
}
