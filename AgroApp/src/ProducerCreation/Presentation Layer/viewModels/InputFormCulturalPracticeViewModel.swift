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
import Combine

final class InputFormCulturalPracticeViewModelImpl: InputFormCulturalPracticeViewModel {
    
    private let stateObserver: Observable<InputFormCulturalPracticeState>
    let viewState: ViewState
    var state: InputFormCulturalPracticeState?
    var disposableInputFormCulturalViewState: Disposable?
    var disposableDispatcher: Disposable?
    var disposableActivateAnimation: Disposable?
    var settingViewController: SettingViewController<InputFormCulturalPracticeView>?
    var interraction: InputFormCulturalPracticeInteraction
    var cancellableInputValue: AnyCancellable?

    init(
        stateObserver: Observable<InputFormCulturalPracticeState>,
        viewState: ViewState,
        inputFormCulturalPracticeInterraction: InputFormCulturalPracticeInteraction
    ) {
        self.stateObserver = stateObserver
        self.viewState = viewState
        self.interraction = inputFormCulturalPracticeInterraction
    }

    func subscribeToInputFormCulturalPracticeStateObs() {
        self.disposableInputFormCulturalViewState = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe {[weak self] event in
                
                guard let self = self,
                    let state = event.element,
                    let actionResponse = state.actionResponse
                    else { return }

                self.setValue(state: state)

                switch actionResponse {
                case .inputElementSelectedOnListActionResponse:
                    self.handleInputElementSelectedOnListActionResponse()
                case .closeInputFormWithSaveActionResponse:
                    self.handleCloseInputFormWithSaveActionResponse()
                case .closeInputFormWithoutSaveActionResponse:
                    self.handleCloseWithoutSave()
                case .checkIfInputValueIsValidActionResponse:
                    self.handleCheckIfInputValueIsValidActionResponse()
                case .checkIfFormIsValidAndDirtyForPrintAlertActionResponse(isPrintAlert: let isPrintAlert):
                    self.handleCheckIfFormIsValidAndDirtyForPrintAlertActionResponse(isPrintAlert: isPrintAlert)
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
        cancellableInputValue?.cancel()
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
        guard let inputElementObservable = state?.inputElementObservable else {
            return
        }
        
        self.viewState.inputElementObservale = inputElementObservable
    }
    
    private func refreshAllView() {
        self.viewState.objectWillChange.send()
        
        if let inputElementObservalble = self.viewState.inputElementObservale {
            inputElementObservalble.objectWillChange.send()
        }
    }
    
    private func subscribeToInputValueChange() {
        if let inputElementObservable = viewState.inputElementObservale {
            self.cancellableInputValue = inputElementObservable.$value
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink {[weak self] value in
                    self?.interraction.checkIfInputValueIsValidAction(value)
            }
        }
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

    private func dismissForm() {
        settingViewController?.dismissVC(completion: nil)
    }

    private func isFormDirty() -> Bool {
        state?.isDirty ?? false
    }

    private func printAlert() {
        viewState.isPrintAlert = true
    }

    private func closeAlert() {
        viewState.isPrintAlert = false
    }

    class ViewState: ObservableObject {
        var inputElementObservale: InputElementObservable!
        var hasAnimation: Bool = false
        var isDismissForm: Bool = false
        @Published var isPrintAlert: Bool = false
        var textAlert: String = "Voulez-vous enregistrer la valeur saisie ?"
        var textButtonValidate: String = "Valider"
        var textErrorMessage: String = "Veuillez saisir une valeur valide"
    }

    deinit {
        print("***** denit InputFormCulturalPracticeViewModelImpl *******")
    }
}

// Handler
extension InputFormCulturalPracticeViewModelImpl {
    private func handleInputElementSelectedOnListActionResponse() {
        setValuesViewState()
        refreshAllView()
        subscribeToInputValueChange()
        activatedAnimationOfView()
    }
    
    private func handleCheckIfInputValueIsValidActionResponse() {
        setValuesViewState()
        refreshAllView()
    }

    private func handleCloseInputFormWithSaveActionResponse() {
        guard let section = state?.sectionInputElement, let field = state?.field else {
            return
        }
        
        interraction.updateCulturalPracticeElementAction(section, field)
        dismissForm()
    }
    
    private func handleCheckIfFormIsValidAndDirtyForPrintAlertActionResponse(isPrintAlert: Bool) {
        if isPrintAlert {
            return self.printAlert()
        }
        
        interraction.closeInputFormWithoutSaveAction()
    }

    func handleButtonValidate() {
        guard let inputElementObservable = viewState.inputElementObservale else {
            return
        }
        
        interraction.closeInputFormWithSaveAction(inputValue: inputElementObservable.value)
    }

    func handleCloseButton() {
        interraction.checkIfFormIsValidAndDirtyForPrintAlertAction()
    }

    func handleCloseWithoutSave() {
        dismissForm()
    }

    func handleAlertYesButton() {
        guard let inputElementObservable = viewState.inputElementObservale else {
            return
        }
        
        interraction.closeInputFormWithSaveAction(inputValue: inputElementObservable.value)
    }

    func handleAlertNoButton() {
        interraction.closeInputFormWithoutSaveAction()
    }
}

protocol InputFormCulturalPracticeViewModel {
    var viewState: InputFormCulturalPracticeViewModelImpl.ViewState {get}
    func subscribeToInputFormCulturalPracticeStateObs()
    func disposeToObs()
    func handleButtonValidate()
    func handleCloseButton()
    func handleAlertYesButton()
    func handleAlertNoButton()
    func configView()
}
