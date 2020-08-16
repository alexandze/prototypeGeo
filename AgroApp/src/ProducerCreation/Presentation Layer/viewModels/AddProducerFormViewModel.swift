//
//  AddProducerFormViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import Combine

class AddProducerFormViewModelImpl: AddProducerFormViewModel {
    let stateObservable: Observable<AddProducerFormState>
    let interaction: AddProducerFormInteraction
    var viewController: SettingViewController<AddProducerFormView>?
    var disposableStateObserver: Disposable?
    var state: AddProducerFormState?
    var viewState: ViewState
    var cancelable: [AnyCancellable] = []

    init(
        addProducerFormStateObservable: Observable<AddProducerFormState>,
        addProducerFormInteraction: AddProducerFormInteraction,
        viewState: ViewState
    ) {
        self.stateObservable = addProducerFormStateObservable
        self.interaction = addProducerFormInteraction
        self.viewState = viewState
    }

    func subscribeToStateObservable() {
        interaction.getListElementUIDataWithoutValueAction()

        self.disposableStateObserver = stateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe {[weak self] event in
                guard let state = event.element,
                    let responseAction = state.responseAction
                    else { return }

                self?.setValues(addProducerFormState: state)

                switch responseAction {
                case .getListElementUIDataWihoutValueResponse:
                    self?.handleGetAllElementUIDataWihoutValueResponse()
                case .checkIfInputElemenIsValidActionResponse(index: let index):
                    self?.handleCheckIfInputElemenIsValidActionResponse(index: index)
                case .checkIfAllInputElementIsValidActionResponse(isAllInputValid: let isAllInputValid):
                    self?.handleCheckIfAllInputElementIsValidActionResponse(isAllInputValid: isAllInputValid)
                case .addNimInputElementActionResponse(indexOfNewNimInputElement: let indexOfNewNimInputElement):
                    self?.handleAddNimInputElementActionResponse(indexOfNewNimInputElement: indexOfNewNimInputElement)
                case .notResponse:
                    break
                }
        }
    }

    func configView() {
        self.viewController?.setBackgroundColor(Util.getBackgroundColor())
        self.viewController?.setAlpha(Util.getAlphaValue())
        // self.viewController?.setIsModalInPresentation(true)
        self.viewController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.interaction.setTitleContainerTitleNavigation(title: "Saisir information producteur")
        self.interaction.setCurrentViewControllerInNavigation()
        // TODO dispatch isAppear
        // self.viewController?.title = "Nouveau Agriculteur"
        // self.viewController?.navigationController?.navigationBar.prefersLargeTitles = true
    }

    func dispose() {
        // viewController = nil
        _ = Util.runInSchedulerBackground {
            self.disposableStateObserver?.dispose()
        }
    }

    func subscribeToFormObserver() {
        viewState.elementUIDataObservableList.forEach { elementUIData in
            guard let elementUIData = elementUIData as? InputElementDataObservable else {
                return
            }

            cancelable.append(
                elementUIData.$value
                    .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink {[weak self] value in
                        self?.interaction.checkIfInputElemenIsValidAction(id: elementUIData.id, value: value)
                        self?.interaction.checkIfAllInputElementIsValidAction()
                }
            )
        }
    }

    func cancelableObservableForm() {
        while !cancelable.isEmpty {
            cancelable.popLast()?.cancel()
        }
    }

    func disposeViewController() {
        viewController = nil
    }

    private func setValues(addProducerFormState: AddProducerFormState) {
        self.state = addProducerFormState
    }

    private func setViewStateValue() {
        guard let elementUIDataObservableList = state?.elementUIDataObservableList,
            let addButtonElementObservable = state?.addButtonElementObservable
            else { return }

        viewState.elementUIDataObservableList = elementUIDataObservableList
        viewState.addElementButton = addButtonElementObservable
        viewState.objectWillChange.send()
    }

    private func sendObjectChangeInputElementByIndex(_ index: Int) {
        viewState.elementUIDataObservableList[index].objectWillChange.send()
    }

    private func setInputElement(_ elementUIData: ElementUIDataObservable, index: Int) {
        viewState.elementUIDataObservableList[index] = elementUIData
        viewState.elementUIDataObservableList[index].objectWillChange.send()
    }

    class ViewState: ObservableObject {
        var elementUIDataObservableList: [ElementUIDataObservable] = []
        var isAllInputValid = false
        var addElementButton: ButtonElementObservable?
    }
}

extension AddProducerFormViewModelImpl {
    func handleAddNimButton() {
        self.interaction.addNimInputElementAction()
    }

    func handleValidateButton() {
        // print(viewState.utilElementUIDataSwiftUIList[0].valueState)
        // TODO Dispatch action

        guard let appDependency = Util.getAppDependency() else { return }
        self.viewController?.navigationController?.pushViewController(appDependency.makeFieldListViewController(), animated: true)
    }

    func handleRemoveNimButton() {
        // TODO remove nim
        print("remove NIM")
    }

    private func handleAddNimInputElementActionResponse(indexOfNewNimInputElement: Int) {
        print(indexOfNewNimInputElement)
        setViewStateValue()
        sendObjectChangeInputElementByIndex(indexOfNewNimInputElement)
        cancelableObservableForm()
        subscribeToFormObserver()
        interaction.checkIfAllInputElementIsValidAction()
    }

    private func handleGetAllElementUIDataWihoutValueResponse() {
        setViewStateValue()
        cancelableObservableForm()
        subscribeToFormObserver()
        self.interaction.checkIfAllInputElementIsValidAction()
    }

    private func handleCheckIfInputElemenIsValidActionResponse(index: Int) {
        guard let elementUIDataObservable = state?.elementUIDataObservableList?[index] else {
            return
        }

        setInputElement(elementUIDataObservable, index: index)
    }

    private func handleCheckIfAllInputElementIsValidActionResponse(isAllInputValid: Bool) {
        self.viewState.isAllInputValid = isAllInputValid
        self.viewState.objectWillChange.send()
    }
}

protocol AddProducerFormViewModel {
    var viewController: SettingViewController<AddProducerFormView>? {get set}
    var viewState: AddProducerFormViewModelImpl.ViewState { get }
    func configView()
    func subscribeToStateObservable()
    func dispose()
    func handleValidateButton()
    func handleAddNimButton()
    func handleRemoveNimButton()
}
