//
//  AddProducerFormViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class AddProducerFormViewModelImpl: AddProducerFormViewModel {
    let stateObservable: Observable<AddProducerFormState>
    let interaction: AddProducerFormInteraction
    var viewController: SettingViewController<AddProducerFormView>?
    var disposableStateObserver: Disposable?
    var state: AddProducerFormState?
    var viewState: ViewState

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
                
                print(state)
                self?.setValues(addProducerFormState: state)

                switch responseAction {
                case .getListElementUIDataWihoutValueResponse:
                    self?.handleGetListElementUIDataWihoutValueResponse()
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
        self.interaction.setTitleContainerTitleNavigation(title: "Saisir information agriculteur")
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

    func disposeViewController() {
        viewController = nil
    }

    private func setValues(addProducerFormState: AddProducerFormState) {
        self.state = addProducerFormState
    }

    private func setViewStateValue() {
        guard let listElementUIData = state?.listElementUIData,
            let listElementValue = state?.listElementValue,
            let listElementValid = state?.listElementValid
            else { return }

        viewState.listElementUIData = listElementUIData
        viewState.listElementValue = listElementValue
        viewState.listElementValid = listElementValid
    }

    class ViewState: ObservableObject {
        @Published var listElementUIData: [ElementUIData] = []
        @Published var listElementValue: [String] = []
        @Published var listElementValid: [Bool] = []
    }
}

extension AddProducerFormViewModelImpl {
    func handleButtonValidate() {
        // TODO Dispatch action
        guard let appDependency = Util.getAppDependency() else { return }
        self.viewController?.navigationController?.pushViewController(appDependency.makeFieldListViewController(), animated: true)

    }

    private func handleGetListElementUIDataWihoutValueResponse() {
        setViewStateValue()
    }
}

protocol AddProducerFormViewModel {
    var viewController: SettingViewController<AddProducerFormView>? {get set}
    var viewState: AddProducerFormViewModelImpl.ViewState { get }
    func configView()
    func subscribeToStateObservable()
    func dispose()
    func handleButtonValidate()
}
