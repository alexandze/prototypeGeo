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
    private var disposableStateObserver: Disposable?
    private var state: ContainerFormCulturalPracticeState?
    private var disposeDispatcher: Disposable?
    private var cancellableList: [AnyCancellable] = []
    var settingViewController: SettingViewController<ContainerFormCulturalPracticeView>?
    var interaction: ContainerFormCulturalPracticeInteraction
    
    init(
        stateObserver: Observable<ContainerFormCulturalPracticeState>,
        viewState: ViewState,
        interaction: ContainerFormCulturalPracticeInteraction
    ) {
        self.stateObserver = stateObserver
        self.viewState = viewState
        self.interaction = interaction
    }
    
    func subscribeToStateObserver() {
        disposableStateObserver = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let state = event.element,
                    let actionResponse = state.actionResponse else { return }
                
                self.setValue(state: state)
                
                switch actionResponse {
                case .containerElementSelectedOnListActionResponse:
                    self.handleContainerElementSelectedOnListActionSuccess()
                case .checkIfFormIsDirtyAndValidAction(isPrintAlert: let isPrintAlert):
                    self.handleCheckIfFormIsDirtyAndValidAction(isPrintAlert)
                case .checkIfInputValueIsValidActionResponse(indexElementUIData: let indexElementUIData):
                    self.handleCheckIfInputValueIsValidActionResponse(indexElementUIData)
                case .closeContainerFormWithSaveActionResponse:
                    self.handleCloseContainerFormWithSaveActionResponse()
                case .closeContainerFormWithoutSaveActionResponse:
                    self.handleCloseContainerFormWithoutSaveActionResponse()
                }
        }
    }
    
    func disposeObserver() {
        settingViewController = nil
        
        _ = Util.runInSchedulerBackground {
            self.disposableStateObserver?.dispose()
        }
        
        while !cancellableList.isEmpty {
            cancellableList.popLast()?.cancel()
        }
    }
    
    func configView() {
        self.settingViewController?.setBackgroundColor(Util.getBackgroundColor())
        self.settingViewController?.setAlpha(Util.getAlphaValue())
        self.settingViewController?.setIsModalInPresentation(true)
    }
    
    private func setTitleForm() {
        if let nameSection = self.state?.section?.sectionName, let indexSection = self.state?.section?.index {
            viewState.titleForm = "\(nameSection) \(indexSection + 1)"
        }
    }
    
    private func setViewStateValue() {
        if let elementUIDataObservableList = self.state?.elementUIDataObservableList {
            viewState.elementUIDataObservableList = elementUIDataObservableList
            
            viewState.elementUIDataObservableList.forEach { elementUIDataObservable in
                elementUIDataObservable.objectWillChange.send()
            }
        }
        
        if let isFormValid = state?.isFormValid {
            viewState.isFormValid = isFormValid
        }
        
        viewState.objectWillChange.send()
    }
    
    private func setElementUIDataByIndex(_ indexElementUIData: Int) {
        guard let elementUIDataObservableList = state?.elementUIDataObservableList else { return }
        let inputElement = elementUIDataObservableList[indexElementUIData]
        self.viewState.elementUIDataObservableList[indexElementUIData] = inputElement
        self.viewState.elementUIDataObservableList[indexElementUIData].objectWillChange.send()
        
        if let isFormValid = state?.isFormValid {
            viewState.isFormValid = isFormValid
        }
        
        viewState.objectWillChange.send()
    }
    
    private func subscribeToChangeInputValue() {
        viewState.elementUIDataObservableList.forEach { elementUIDataObservable in
            if let inputElementObservable = elementUIDataObservable.toInputElementObservable() {
                cancellableList.append(
                    inputElementObservable.$value
                        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                        .removeDuplicates()
                        .sink { [weak self] value in
                            self?.interaction.checkIfInputValueIsValidAction(inputElementObservable.id, value: value)
                            // check if all inputValue is Valid
                    }
                )
            }
        }
    }
    
    private func dismissContainerWithSave() {
        guard let newSection = state?.section, let field = state?.field else {
            return
        }
        
        interaction.updateCulturalPracticeElementAction(section: newSection, field: field)
        dismissForm()
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
        var elementUIDataObservableList: [ElementUIDataObservable] = []
        var titleForm: String = ""
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
        interaction.closeContainerFormWithSaveAction()
    }
    
    func handleButtonClose() {
        interaction.checkIfFormIsDirtyAndValidAction()
    }
    
    func handleAlertYesButton() {
        interaction.closeContainerFormWithSaveAction()
    }
    
    func handleAlertNoButton() {
        interaction.closeContainerFormWithoutSaveAction()
    }
    
    private func handleContainerElementSelectedOnListActionSuccess() {
        setTitleForm()
        setViewStateValue()
        subscribeToChangeInputValue()
    }
    
    private func handleCheckIfFormIsDirtyAndValidAction(_ isPrintAlert: Bool) {
        if isPrintAlert {
            return printAlert()
        }
        
        interaction.closeContainerFormWithoutSaveAction()
    }
    
    private func handleCheckIfInputValueIsValidActionResponse(_ indexElementUIData: Int) {
        // self.setElementUIDataByIndex(indexElementUIData)
        setViewStateValue()
    }
    
    private func handleCloseContainerFormWithSaveActionResponse() {
        dismissContainerWithSave()
    }
    
    private func handleCloseContainerFormWithoutSaveActionResponse() {
        self.dismissForm()
    }
}

protocol ContainerFormCulturalPracticeViewModel {
    var viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState { get }
    func subscribeToStateObserver()
    func disposeObserver()
    func handleButtonValidate()
    func handleButtonClose()
    func handleAlertYesButton()
    func handleAlertNoButton()
    func configView()
}
