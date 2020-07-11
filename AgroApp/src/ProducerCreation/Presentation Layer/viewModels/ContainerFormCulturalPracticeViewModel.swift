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

class ContainerFormCulturalPracticeViewModelImpl: ContainerFormCulturalPracticeViewModel {
    let viewState: ViewState
    var view: ContainerElementView?
    private let stateObserver: Observable<ContainerFormCulturalPracticeState>
    private let actionDispatcher: ActionDispatcher
    private var disposableStateObserver: Disposable?
    private var state: ContainerFormCulturalPracticeState?
    private var disposeDispatcher: Disposable?

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
                case .newFormData:
                    self.handleNewFormData()
                case .newIsDirtyAndIsFormValidValue:
                    self.handleNewIsDirtyAndIsFormValidValue()

                }
        }
    }

    func disposeObserver() {
        disposableStateObserver?.dispose()
    }

    private func setViewStateValue() {
        viewState.titleForm = state!.containerElement!.title
        viewState.inputElements = state!.inputElements!
        viewState.selectElements = state!.selectElements!
        viewState.inputValues = state!.inputValues!
        viewState.selectValue = state!.selectValues!
    }

    private func setValue(
        state: ContainerFormCulturalPracticeState
    ) {
        self.state = state
    }

    private func createCheckIfFormIsDirtyAction() -> ContainerFormCulturalPracticeAction.CheckIfFormIsDirtyAndValidAction {
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

    class ViewState: ObservableObject {
        @Published var titleForm: String = ""
        @Published var inputElements: [CulturalPracticeInputElement] = []
        @Published var selectElements: [CulturalPracticeMultiSelectElement] = []
        @Published var inputValues: [String] = []
        @Published var selectValue: [Int] = []
        @Published var isButtonValidateActivated: Bool = false
        @Published var presentAlert: Bool = false
        @Published var textAlert: String = "Voulez-vous enregistrer les valeurs saisies ?"
        @Published var textButtonValidate: String = "Valider"
        @Published var textErrorMessage: String = "Veuillez saisir une valeur valide"

    }
}

// handler
extension ContainerFormCulturalPracticeViewModelImpl {
    private func handleNewFormData() {
        setViewStateValue()
    }

    private func handleNewIsDirtyAndIsFormValidValue() {
        if isDirtyAndIsFormValid() {
            printAlert()
        }

        print(isDirtyAndIsFormValid() ? "printAlert" : "not print Alert")
    }

    func handleButtonValidate() {
        // TODO dispatch save form with save
    }

    func handleButtonClose() {
        dispatchCheckIfFormIsDirtyAction()
    }

    func handleAlertYesButton() {
        // TODO dispatch update form
    }

    func handleAlertNoButton() {
        // TODO dispatch close, no save
    }
}

// Dispatcher
extension ContainerFormCulturalPracticeViewModelImpl {
    private func dispatchCheckIfFormIsDirtyAction() {
        let checkIfFormIsDirtyAction = createCheckIfFormIsDirtyAction()

        disposeDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(checkIfFormIsDirtyAction)
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
}
