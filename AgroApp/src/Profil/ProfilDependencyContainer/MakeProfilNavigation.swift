//
//  MakeProfilNavigation.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit
import SwiftUI

class ProfilMakeNavigationImpl: ProfilMakeNavigation {
    let stateStore: Store<AppState>

    init(stateStore: Store<AppState>) {
        self.stateStore = stateStore
    }
    
    func makeProfilStateObservable() -> Observable<ProfilState> {
        stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<ProfilState> in
            subscription.select { appState in
                appState.profilState
            }.skip {$0 == $1}
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }
    
    func makeProfilInteraction() -> ProfilInteraction {
        ProfilInteractionImpl(actionDispatcher: stateStore)
    }
    
    func makeProfilViewModel(_ viewState: ProfilViewModelImpl.ViewState) -> ProfilViewModel {
        ProfilViewModelImpl(profilStateObserver: makeProfilStateObservable(), profilInteraction: makeProfilInteraction(), viewState: viewState)
    }
    
    func makeProfilView(
        _ viewModel: ProfilViewModel,
        _ viewState: ProfilViewModelImpl.ViewState
    ) -> ProfilView {
        ProfilView(viewModel: viewModel, viewState: viewState)
    }
    
    func makeProfilViewState() -> ProfilViewModelImpl.ViewState {
        ProfilViewModelImpl.ViewState()
    }
    
    func makeProfilNavigation() -> UINavigationController {
        let profilViewState = makeProfilViewState()
        var profilViewModel = makeProfilViewModel(profilViewState)
        let profilView = makeProfilView(profilViewModel, profilViewState)
        let settingViewController = SettingViewController(myView: profilView)
        profilViewModel.viewController = settingViewController
        return UINavigationController(rootViewController: settingViewController)
    }
}

protocol ProfilMakeNavigation {
    func makeProfilNavigation() -> UINavigationController
}
