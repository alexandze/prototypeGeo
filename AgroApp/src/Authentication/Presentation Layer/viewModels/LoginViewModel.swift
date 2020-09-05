//
//  LoginViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class LoginViewModelImpl: LoginViewModel {
    let loginStateObservable: Observable<LoginState>
    let loginInteraction: LoginInteraction
    let viewState: ViewState
    var viewController: SettingViewController<LoginView>?
    
    init(
        loginStateObservable: Observable<LoginState>,
        loginInteraction: LoginInteraction,
        viewState: ViewState
    ) {
        self.loginStateObservable = loginStateObservable
        self.loginInteraction = loginInteraction
        self.viewState = viewState
    }
    
    class ViewState: ObservableObject {
        
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
}

protocol LoginViewModel {
    var viewController: SettingViewController<LoginView>? { get set }
    func handleConnexionButton()
}
