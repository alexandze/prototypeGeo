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
    var disposableInputFormCulturalViewState: Disposable?
    var disposableDispatcher: Disposable?
    var disposableActivateAnimation: Disposable?
    var inputElement: CulturalPracticeInputElement?
    var firstInputValue: String?
    var regularExpressionForInputValue: NSRegularExpression?
    var fieldType: FieldType?
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
                guard let inputElement = event.element?.inputElement,
                    let fieldType = event.element?.fieldType,
                    let subAction = event.element?.inputFormSubAction
                    else { return }

                self.setValue(inputElement: inputElement, fieldType: fieldType)
                self.initRegularExpression()
                self.setFirstInputValue()

                switch subAction {
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

    func isInputValueValid(_ inputValue: String) -> Bool {
        let inputValueTrim = trim(inputValue: inputValue)

        guard !inputValueTrim.isEmpty,
            let regularExpressionForInputValue =  regularExpressionForInputValue else { return false }

        let matches = mathesRegularExpression(
            inputValueTrim: inputValueTrim,
            regularExpression: regularExpressionForInputValue
        )

        return matches.count == 1
    }

    func configView() {
        self.settingViewController?.setBackgroundColor(Util.getBackgroundColor())
        self.settingViewController?.setAlpha(Util.getAlphaValue())
        self.settingViewController?.setIsModalInPresentation(true)
    }

    private func setFirstInputValue() {
        guard firstInputValue == nil,
            let culturalPracticeValueProtocol = inputElement?.value else {
                firstInputValue = ""
                return
        }

        firstInputValue = culturalPracticeValueProtocol.getValue()
    }

    private func trim(inputValue: String) -> String {
        inputValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func createRegularExpressionFrom() throws -> NSRegularExpression {
        let regularExpressionString = type(of: inputElement!.valueEmpty).getRegularExpression()!
        return try NSRegularExpression(pattern: regularExpressionString, options: [])
    }

    private func initRegularExpression() {
        guard regularExpressionForInputValue == nil else { return }

        do {
            regularExpressionForInputValue = try createRegularExpressionFrom()
        } catch { }
    }

    private func mathesRegularExpression(
        inputValueTrim: String,
        regularExpression: NSRegularExpression
    ) -> [NSTextCheckingResult] {
        regularExpression.matches(
            in: inputValueTrim, options: [],
            range: NSRange(location: 0, length: inputValueTrim.count)
        )
    }

    private func setValue(inputElement: CulturalPracticeInputElement, fieldType: FieldType) {
        self.inputElement = inputElement
        self.fieldType = fieldType
    }

    private func setValuesViewState() {
        viewState.title = inputElement!.title
        viewState.subTitle = "Veuillez saisir la valeur pour la parcelle \(fieldType!.getId())"
        viewState.inputTitle = inputElement!.valueEmpty.getUnitType()?.convertToString() ?? ""
        viewState.inputValue = inputElement!.value?.getValue() ?? ""
        viewState.unitType = inputElement!.valueEmpty.getUnitType()?.convertToString() ?? ""
    }

    /// Activated animation of view. There is one second timeout for activate animation
    private func activatedAnimationOfView() {
        self.disposableActivateAnimation = Observable.just(true)
            .timeout(.milliseconds(1), scheduler: Util.getSchedulerBackground())
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                if let value = event.element {
                    self.viewState.hasAnimation = value
                }
        }
    }

    private func getValueFromInputElement() -> String {
        guard let inputValue = inputElement?.value?.getValue() else { return "" }
        return inputValue
    }

    private func dismissForm() {
        settingViewController?.dismissVC(completion: nil)
    }

    private func isFormDirty() -> Bool {
        return firstInputValue! != viewState.inputValue
    }

    private func printAlert() {
        viewState.isPrintAlert = true
    }

    private func closeAlert() {
        viewState.isPrintAlert = false
    }

    class ViewState: ObservableObject {
        @Published var inputValue: String = ""
        @Published var inputTitle: String = ""
        @Published var subTitle: String = ""
        @Published var title: String = ""
        @Published var unitType: String = ""
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
        if isFormDirty() && isInputValueValid(viewState.inputValue) {
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
        let closeInputFormWithSaveAction = InputFormCulturalPracticeAction
            .CloseInputFormWithSaveAction(inputValue: trim(inputValue: viewState.inputValue))
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(closeInputFormWithSaveAction)
        }
    }

    private func dispathUpdateCulturalPracticeElementAction() {
        let action = CulturalPracticeFormAction
            .UpdateCulturalPracticeElementAction(
                culturalPracticeElementProtocol: inputElement!,
                fieldType: fieldType!
        )
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

    private func dispatchCloseInputFormWithoutSaveAction() {
        let action = InputFormCulturalPracticeAction.CloseInputFormWithoutSaveAction()
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
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
