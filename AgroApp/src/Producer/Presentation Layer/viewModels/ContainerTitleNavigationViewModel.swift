//
//  ContainerTitleNavigationViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import ReSwift

class ContainerTitleNavigationViewModelImpl: ContainerTitleNavigationViewModel {

    let stateObservable: Observable<ContainerTitleNavigationState>
    let actionDispatcher: ActionDispatcher
    var disposableState: Disposable?
    var state: ContainerTitleNavigationState?
    var subjectViewState = PublishSubject<ViewState>()
    var disposableDispatcher: Disposable?

    init(
        stateObservable: Observable<ContainerTitleNavigationState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.stateObservable = stateObservable
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToStateObserver() {
        disposableState = stateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let state = event.element, let subAction = state.subAction else { return }
                self.setValues(state: state)

                switch subAction {
                case .setTitleActionSuccess:
                    self.handleSetTitleActionSuccess()
                case .setCurrentViewControllerInNavigationActionSuccess:
                    self.handleSetCurrentViewControllerInNavigationActionSuccess()
                case .hideButttonActionSuccess:
                    self.handleHideCloseButtonActionSuccess()
                case .printButtonActionSuccess:
                    self.handlePrintCloseButtonActionSuccess()
                case .backActionSuccess:
                    self.handleBackActionSuccess()
                case .notResponse:
                    break
                }
        }
    }

    func setValues(state: ContainerTitleNavigationState) {
        self.state = state
    }

    func disposeObservers() {
        _ = Util.runInSchedulerBackground {
            self.disposableState?.dispose()
        }
        
        subjectViewState.dispose()
    }

    enum ViewState {
        case setCurrentViewControllerInNavigation(
            currentViewControllerInNavigation: ContainerTitleNavigationState.CurrentViewControllerInNavigation
        )

        case hideCloseButton
        case printCloseButton
        case setTitle(title: String)
        case back
    }

}

extension ContainerTitleNavigationViewModelImpl {
    func handleHideCloseButtonActionSuccess() {
        subjectViewState.onNext(.hideCloseButton)
    }

    func handlePrintCloseButtonActionSuccess() {
        subjectViewState.onNext(.printCloseButton)
    }

    func handleSetTitleActionSuccess() {
        subjectViewState.onNext(.setTitle(title: state?.title ?? ""))
    }

    func handleSetCurrentViewControllerInNavigationActionSuccess() {
        subjectViewState.onNext(
            .setCurrentViewControllerInNavigation(
                currentViewControllerInNavigation: state!.currentViewController!
            )
        )
    }

    func handleCloseButton() {
        dispatchBackActionButton()
    }

    func handleBackActionSuccess() {
        subjectViewState.onNext(.back)
    }
}

// Dispatcher
extension ContainerTitleNavigationViewModelImpl {

    func dispatchHideCloseButtonAction() {
        let action = ContainerTitleNavigationAction.HideCloseButtonAction()
        dispatch(action: action)
    }

    func dispatchPrintCloseButtonAction() {
        let action = ContainerTitleNavigationAction.PrintCloseButtonAction()
        dispatch(action: action)
    }

    private func dispatchBackActionButton() {
        let action = ContainerTitleNavigationAction.BackAction()
        dispatch(action: action)
    }

    private func dispatch(action: Action) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(action)
        }
    }
}

protocol ContainerTitleNavigationViewModel {
    var subjectViewState: PublishSubject<ContainerTitleNavigationViewModelImpl.ViewState> { get }
    func subscribeToStateObserver()
    func disposeObservers()
    func handleCloseButton()
    func dispatchHideCloseButtonAction()
    func dispatchPrintCloseButtonAction()
}
