//
//  ProfilViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class ProfilViewModelImpl: ProfilViewModel {
    
    let stateObserver: Observable<ProfilState>
    let interaction: ProfilInteraction
    weak var viewState: ViewState?
    weak var viewController: SettingViewController<ProfilView>?
    private var disposableStateObserver: Disposable?
    private var state: ProfilState?
    
    init(
        profilStateObserver: Observable<ProfilState>,
        profilInteraction: ProfilInteraction,
        viewState: ViewState
    ) {
        self.stateObserver = profilStateObserver
        self.interaction = profilInteraction
        self.viewState = viewState
    }
    
    func handleOnAppear() {
        configView()
        subscribeStateObserver()
    }
    
    func handleOnDisappear() {
        disposeStateObservable()
    }
    
    private func configView() {
        self.viewController?.setBackgroundColor(Util.getBackgroundColor())
        self.viewController?.setAlpha(Util.getAlphaValue())
        self.viewController?.navigationController?.setNavigationBarHidden(false, animated: true)
        self.viewController?.title = "Profil"
    }
    
    private func subscribeStateObserver() {
        disposableStateObserver = stateObserver
            .observeOn(Util.getSchedulerMain())
            .subscribe { element in
                guard let profilState = element.element,
                    let actionResponse = profilState.actionResponse else {
                        return
                }
                
                self.state = profilState
                
                switch actionResponse {
                case .notResponse:
                    break
                }
        }
    }
    
    private func disposeStateObservable() {
        guard let disposable = disposableStateObserver else {
            return
        }
        
        Util.disposeStateObservable(disposable)
    }
    
    class ViewState: ObservableObject {
        
    }
}

protocol ProfilViewModel {
    var viewController: SettingViewController<ProfilView>? { get set }
    func handleOnAppear()
    func handleOnDisappear()
}
