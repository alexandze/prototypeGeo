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

class InputFormCulturalPracticeViewModelImpl: InputFormCulturalPracticeViewModel {
    let stateObserver: Observable<InputFormCulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    let viewState = ViewState()
    var view: InputFormCulturalPracticeView?
    var disposableInputFormCulturalViewState: Disposable?
    var disposableDispatcher: Disposable?
    var disposableActivateAnimation: Disposable?
    var inputElement: CulturalPracticeInputElement?

    init(
        stateObserver: Observable<InputFormCulturalPracticeState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.stateObserver = stateObserver
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToInputFormCulturalPracticeStateObs() {
        self.disposableInputFormCulturalViewState = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let inputElement = event.element?.inputElement,
                    let fieldType = event.element?.fieldType,
                    let subAction = event.element?.inputFormSubAction
                    else { return }

                self.setValue(inputElement: inputElement)

                switch subAction {
                case .newFormData:
                    self.handleNewFormData(inputElement, fieldType)
                case .closeWithSave:
                    self.handleCloseWithSave(inputElement)
                case .noAction:
                    break
                }
        }
    }

    func disposeToObs() {
        disposableInputFormCulturalViewState?.dispose()
        disposableActivateAnimation?.dispose()
        // disposableDispatcher?.dispose()
    }

    func isInputValueValid(_ inputValue: String) -> Bool {
        let inputValueTrim = trim(inputValue: inputValue)

        if let inputElement = inputElement, !inputValueTrim.isEmpty {
            do {
                let regularExpression = try createRegularExpressionFrom(inputElement: inputElement)

                let matches = mathesRegularExpression(
                    inputValueTrim: inputValueTrim,
                    regularExpression: regularExpression
                )

                return matches.count == 1 ? true : false
            } catch {
                return false
            }
        }

        return false
    }

    private func trim(inputValue: String) -> String {
        inputValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func createRegularExpressionFrom(inputElement: CulturalPracticeInputElement) throws -> NSRegularExpression {
        let regularExpressionString = type(of: inputElement.valueEmpty).getRegularExpression()!
        return try NSRegularExpression(pattern: regularExpressionString, options: [])
    }

    private func mathesRegularExpression(inputValueTrim: String, regularExpression: NSRegularExpression) -> [NSTextCheckingResult] {
        regularExpression.matches(in: inputValueTrim, options: [], range: NSRange(location: 0, length: inputValueTrim.count))
    }

    private func setValue(inputElement: CulturalPracticeInputElement) {
        self.inputElement = inputElement
    }

    private func setViewStateWith(
        title: String,
        idField: Int,
        inputValue: String,
        unitType: UnitType
    ) {

        viewState.title = title
        viewState.subTitle = "Veuillez saisir la valeur \"\(title)\" pour la parcelle \(idField)"
        viewState.inputTitle = unitType.convertToString()
        viewState.inputValue = inputValue
        viewState.unitType = unitType.convertToString()
    }

    private func getIdOf(fieldType: FieldType) -> Int {
        switch fieldType {
        case .multiPolygon(let multiPolygon):
            return multiPolygon.id
        case .polygon(let polygon):
            return polygon.id
        }
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

    private func getValueFrom(inputElement: CulturalPracticeInputElement) -> String {
        guard let inputValue = inputElement.value?.getValue() else { return "" }
        return inputValue
    }

    private func dismissForm() {
        viewState.isDismissForm = true
    }

    class ViewState: ObservableObject {
        @Published var inputValue: String = ""
        @Published var inputTitle: String = ""
        @Published var subTitle: String = ""
        @Published var title: String = ""
        @Published var unitType: String = ""
        @Published var hasAnimation: Bool = false
        @Published var isDismissForm: Bool = false
    }
}

// Handler methode
extension InputFormCulturalPracticeViewModelImpl {
    private func handleNewFormData(
        _ inputElement: CulturalPracticeInputElement,
        _ fieldType: FieldType
    ) {
        setViewStateWith(
            title: inputElement.title,
            idField: getIdOf(fieldType: fieldType),
            inputValue: getValueFrom(inputElement: inputElement),
            unitType: inputElement.valueEmpty.getUnitType()!
        )

        activatedAnimationOfView()
    }

    private func handleCloseWithSave(_ inputElement: CulturalPracticeInputElement) {
        dispathUpdateCulturalPracticeElementAction(culturalPracticeElementProtocol: inputElement)
        dismissForm()
    }

    func handleButtonValidate() {
        let inputValue = viewState.inputValue
        dispatchCloseInputFormWithSaveAction(inputValue: inputValue)
    }
}

// Dispatcher
extension InputFormCulturalPracticeViewModelImpl {
    private func dispatchCloseInputFormWithSaveAction(inputValue: String) {
        let closeInputFormWithSaveAction = InputFormCulturalPracticeAction
            .CloseInputFormWithSaveAction(inputValue: inputValue)

        disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(closeInputFormWithSaveAction)
        }
    }

    private func dispathUpdateCulturalPracticeElementAction(
        culturalPracticeElementProtocol: CulturalPracticeElementProtocol
    ) {
        let action = CulturalPracticeFormAction
            .UpdateCulturalPracticeElementAction(
                culturalPracticeElementProtocol: culturalPracticeElementProtocol
        )

        disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }

}

protocol InputFormCulturalPracticeViewModel {
    var viewState: InputFormCulturalPracticeViewModelImpl.ViewState {get}
    var view: InputFormCulturalPracticeView? { get set }
    func subscribeToInputFormCulturalPracticeStateObs()
    func disposeToObs()
    func handleButtonValidate()
    func isInputValueValid(_ inputValue: String) -> Bool
}
