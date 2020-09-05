//
//  AuthenticationDependencyContainer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import RxSwift
import ReSwift
import UIKit
import SwiftUI

class AuthenticationDependencyContainerImpl: AuthenticationDependencyContainer {
    let stateStore: Store<AppState>

    init(stateStore: Store<AppState>) {
        self.stateStore = stateStore
    }
    
    // MARK: - Methods Login
    
    func makeLoginHostingControllerInNavigation() -> UINavigationController {
        UINavigationController(rootViewController: makeLoginHostingController())
    }
    
    private func makeLoginHostingController() -> SettingViewController<LoginView> {
        var loginViewModel = makeLoginViewModel()
        let loginView = makeLoginView(loginViewModel: loginViewModel)
        let hostingViewController = SettingViewController(myView: loginView)
        loginViewModel.viewController = hostingViewController
        return hostingViewController
    }
    
    private func makeLoginObservableState() -> Observable<LoginState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<LoginState> in
            subscription
                .select { $0.loginState }
                .skip { $0.uuidState == $1.uuidState }
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }
    
    private func makeLoginInteraction() -> LoginInteraction {
        LoginInteractionImpl(actionDispatcher: self.stateStore)
    }
    
    private func makeLoginViewState() -> LoginViewModelImpl.ViewState {
        LoginViewModelImpl.ViewState()
    }
    
    private func makeLoginViewModel() -> LoginViewModel {
        LoginViewModelImpl(
            loginStateObservable: makeLoginObservableState(),
            loginInteraction: makeLoginInteraction(),
            viewState: makeLoginViewState()
        )
    }
    
    private func makeLoginView(
        loginViewModel: LoginViewModel
    ) -> LoginView {
        LoginView(loginViewModel:loginViewModel)
    }
}

protocol AuthenticationDependencyContainer {
    func makeLoginHostingControllerInNavigation() -> UINavigationController
}
