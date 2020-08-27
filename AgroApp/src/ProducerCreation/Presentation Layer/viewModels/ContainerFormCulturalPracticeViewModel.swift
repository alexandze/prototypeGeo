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
    private let stateObserver: Observable<ContainerFormCulturalPracticeState>
    private let actionDispatcher: ActionDispatcher
    private var disposableStateObserver: Disposable?
    private var state: ContainerFormCulturalPracticeState?
    private var disposeDispatcher: Disposable?
    private var inputValuesAnyCancellable: AnyCancellable?
    var settingViewController: SettingViewController<ContainerFormCulturalPracticeView>?

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
                    let actionResponse = state.actionResponse else { return }

                self.setValue(state: state)

                switch actionResponse {
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
        
    }

    func disposeObserver() {
        settingViewController = nil

        _ = Util.runInSchedulerBackground {
            self.disposableStateObserver?.dispose()
        }

        self.inputValuesAnyCancellable?.cancel()
    }

    func configView() {
        self.settingViewController?.setBackgroundColor(Util.getBackgroundColor())
        self.settingViewController?.setAlpha(Util.getAlphaValue())
        self.settingViewController?.setIsModalInPresentation(true)
    }

    private func setViewStateValue() {
        
    }

    private func setValue(
        state: ContainerFormCulturalPracticeState
    ) {
        self.state = state
    }

    private func printAlert() {
        viewState.presentAlert = true
    }

    private func dismissForm() {
        // viewState.isDismissForm = true
        settingViewController?.dismissVC(completion: nil)
    }

    class ViewState: ObservableObject {
        @Published var titleForm: String = ""
        var isFormValid: Bool = false
        var presentAlert: Bool = false
        var textAlert: String = "Voulez-vous enregistrer les valeurs saisies ?"
        var textButtonValidate: String = "Valider"
        var textErrorMessage: String = "Veuillez saisir une valeur valide"
        var isDismissForm: Bool = false
    }

    deinit {
        print("***** dinit ContainerFormCulturalPracticeViewModelImpl *******")
    }
}

// handler
extension ContainerFormCulturalPracticeViewModelImpl {

    func handleButtonValidate() {
        
    }

    func handleButtonClose() {
        
    }

    func handleAlertYesButton() {
        
    }

    func handleAlertNoButton() {
        
    }

    private func handleChangeInputValues(inputValues: [String]) {
        
    }

    private func handleContainerElementSelectedOnListActionSuccess() {
        
    }

    private func handleCheckIfFormIsDirtyActionSuccess() {
        
    }

    private func handleCheckIfInputValueIsValidActionSuccess() {
        
    }

    private func handleUpdateContainerElementActionSuccess() {
        
    }
}

// Dispatcher
extension ContainerFormCulturalPracticeViewModelImpl {
    
}

protocol ContainerFormCulturalPracticeViewModel {
    var viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState { get }
    func subscribeToStateObserver()
    func disposeObserver()
    func handleButtonValidate()
    func handleButtonClose()
    func handleAlertYesButton()
    func handleAlertNoButton()
    func subscribeToChangeInputValue()
    func configView()
}
