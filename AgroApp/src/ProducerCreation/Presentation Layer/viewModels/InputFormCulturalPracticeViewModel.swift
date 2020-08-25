//
//  InputFormCulturalPracticeViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI

final class InputFormCulturalPracticeViewModelImpl: InputFormCulturalPracticeViewModel {
    private let stateObserver: Observable<InputFormCulturalPracticeState>
    private let actionDispatcher: ActionDispatcher
    let viewState: ViewState
    var state: InputFormCulturalPracticeState?
    var disposableInputFormCulturalViewState: Disposable?
    var disposableDispatcher: Disposable?
    var disposableActivateAnimation: Disposable?
    var firstInputValue: String?
    var regularExpressionForInputValue: NSRegularExpression?
    var field: Field?
    var settingViewController: SettingViewController<InputFormCulturalPracticeView>?

    init(
        stateObserver: Observable<InputFormCulturalPracticeState>,
        viewState: ViewState,
        actionDispatcher: ActionDispatcher
    ) {
        self.stateObserver = stateObserver
        self.actionDispatcher = actionDispatcher
        self.viewState = viewState
    }

    func subscribeToInputFormCulturalPracticeStateObs() {
        self.disposableInputFormCulturalViewState = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe {event in
                guard let state = event.element,
                    let actionResponse = state.actionResponse
                    else { return }

                self.setValue(state: state)

                switch actionResponse {
                case .newFormData:
                    self.handleNewFormData()
                case .closeWithSave:
                    self.handleCloseWithSave()
                case .closeWithoutSave:
                    self.handleCloseWithoutSave()
                case .noAction:
                    break
                }
        }
    }

    func disposeToObs() {
        settingViewController = nil

        _ = Util.runInSchedulerBackground {
            self.disposableInputFormCulturalViewState?.dispose()
        }

        disposableActivateAnimation?.dispose()
    }

    func configView() {
        self.settingViewController?.setBackgroundColor(Util.getBackgroundColor())
        self.settingViewController?.setAlpha(Util.getAlphaValue())
        self.settingViewController?.setIsModalInPresentation(true)
    }

    private func setValue(state: InputFormCulturalPracticeState) {
        self.state = state
    }

    private func setValuesViewState() {
        
    }

    /// Activated animation of view. There is one second timeout for activate animation
    private func activatedAnimationOfView() {
        self.disposableActivateAnimation = Observable.just(true)
            .timeout(.milliseconds(1), scheduler: Util.getSchedulerBackgroundForReSwift())
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                if let value = event.element {
                    self.viewState.hasAnimation = value
                }
        }
    }

    private func getValueFromInputElement() -> String {
        
    }

    private func dismissForm() {
        settingViewController?.dismissVC(completion: nil)
    }

    private func isFormDirty() -> Bool {
        
    }

    private func printAlert() {
        viewState.isPrintAlert = true
    }

    private func closeAlert() {
        viewState.isPrintAlert = false
    }

    class ViewState: ObservableObject {
        
        @Published var hasAnimation: Bool = false
        @Published var isDismissForm: Bool = false
        @Published var isPrintAlert: Bool = false
        @Published var textAlert: String = "Voulez-vous enregistrer la valeur saisie ?"
        @Published var textButtonValidate: String = "Valider"
        @Published var textErrorMessage: String = "Veuillez saisir une valeur valide"
    }

    deinit {
        print("***** denit InputFormCulturalPracticeViewModelImpl *******")
    }
}

// Handler
extension InputFormCulturalPracticeViewModelImpl {
    private func handleNewFormData() {
        setValuesViewState()
        activatedAnimationOfView()
    }

    private func handleCloseWithSave() {
        dispathUpdateCulturalPracticeElementAction()
        dismissForm()
    }

    func handleButtonValidate() {
        dispatchCloseInputFormWithSaveAction()
    }

    func handleCloseButton() {
        if isFormDirty() {
            return printAlert()
        }

        dispatchCloseInputFormWithoutSaveAction()
    }

    func handleCloseWithoutSave() {
        dismissForm()
    }

    func handleAlertYesButton() {
        dispatchCloseInputFormWithSaveAction()
    }

    func handleAlertNoButton() {
        dispatchCloseInputFormWithoutSaveAction()
    }
}

// Dispatcher
extension InputFormCulturalPracticeViewModelImpl {
    private func dispatchCloseInputFormWithSaveAction() {
        
    }

    private func dispathUpdateCulturalPracticeElementAction() {
        guard let field = field else { return }
        
    }

    private func dispatchCloseInputFormWithoutSaveAction() {
        
    }
}

protocol InputFormCulturalPracticeViewModel {
    var viewState: InputFormCulturalPracticeViewModelImpl.ViewState {get}
    func subscribeToInputFormCulturalPracticeStateObs()
    func disposeToObs()
    func handleButtonValidate()
    func isInputValueValid(_ inputValue: String) -> Bool
    func handleCloseButton()
    func handleAlertYesButton()
    func handleAlertNoButton()
    func configView()
}
