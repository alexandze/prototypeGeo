//
//  LoginViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import Combine

class LoginViewModelImpl: LoginViewModel {
    let loginStateObservable: Observable<LoginState>
    let loginInteraction: LoginInteraction
    var viewState: ViewState
    var viewController: SettingViewController<LoginView>?
    var disposableState: Disposable?
    var state: LoginState?
    var cancelableList: [AnyCancellable] = []
    
    init(
        loginStateObservable: Observable<LoginState>,
        loginInteraction: LoginInteraction,
        viewState: ViewState
    ) {
        self.loginStateObservable = loginStateObservable
        self.loginInteraction = loginInteraction
        self.viewState = viewState
    }
    
    func subscribeToStateObservable() {
        loginInteraction.getElementUIDataListAction()
        
        disposableState = loginStateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe { even in
                guard let state = even.element,
                    let actionResponse = state.actionResponse else { return }
                
                self.setState(state)
                
                switch actionResponse {
                case .getElementUIDataListActionResponse:
                    self.handleGetElementUIDataListActionResponse()
                }
                
        }
    }
    
    func disposes() {
        _ = Util.runInSchedulerBackground {
            self.disposableState?.dispose()
        }
        
        while !cancelableList.isEmpty {
            cancelableList.popLast()?.cancel()
        }
    }
    
    func configView() {
        self.viewController?.setBackgroundColor(Util.getBackgroundColor())
        self.viewController?.setAlpha(Util.getAlphaValue())
        viewController?.title = "Connexion"
    }
    
    private func setState(_ state: LoginState) {
        self.state = state
    }
    
    private func subscribeToInputChange() {
        viewState.elementUIDataObservableList.forEach { elementUIData in
            if let inputElement = elementUIData as? InputElementObservable {
                self.subscribeToInputElementValueChange(inputElement)
            }
        }
    }
    
    private func subscribeToInputElementValueChange(_ inputElement: InputElementObservable) {
        self.cancelableList.append(
            inputElement.$value
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { value in
                    
                    let inputFind = self.viewState.elementUIDataObservableList.first { $0.id == inputElement.id}?.toInputElementObservable()
                    inputFind?.isValid = inputFind?.isInputValid() ?? false
                    
                    (0..<self.viewState.elementUIDataObservableList.count).forEach { index in
                        self.viewState.elementUIDataObservableList[index].objectWillChange.send()
                    }
                    
                    self.viewState.objectWillChange.send()

            }
        )
    }
    
    private func setElementUIDataObservableListOfViewState(_ elementUIDataObservableList: [ElementUIDataObservable]) {
        viewState.elementUIDataObservableList = elementUIDataObservableList
        
        (0..<viewState.elementUIDataObservableList.count).forEach { index in
            viewState.elementUIDataObservableList[index].objectWillChange.send()
        }
        
        viewState.objectWillChange.send()
        viewState.isprint = true
    }
    
    class ViewState: ObservableObject {
        @Published var elementUIDataObservableList: [ElementUIDataObservable] = []
        @Published var isprint: Bool = false
    }
}

extension LoginViewModelImpl {
    func handleConnexionButton() {
        // TODO dispatch
        guard let tabController = Util.getAppDependency()?.proccessInitTabBarController() else {
            return
        }
        
        Util.setRootViewController(tabController)
    }
    
    private func handleGetElementUIDataListActionResponse() {
        guard let elementUIDataObservableList = state?.elementUIDataListObservable else { return }
        setElementUIDataObservableListOfViewState(elementUIDataObservableList)
        subscribeToInputChange()
    }
}

protocol LoginViewModel {
    var viewController: SettingViewController<LoginView>? { get set }
    var viewState: LoginViewModelImpl.ViewState { get set }
    func handleConnexionButton()
    func subscribeToStateObservable()
    func configView()
    func disposes()
}
