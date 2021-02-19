//
//  ContainerMapAndTitleNavigationViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-14.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class ContainerMapAndTitleNavigationViewModelImpl: ContainerMapAndTitleNavigationViewModel {
    let stateObservable: Observable<ContainerMapAndTitleNavigationState>
    let interaction: ContainerMapAndTitleNavigationInteraction
    var state: ContainerMapAndTitleNavigationState?
    var disposeState: Disposable?
    var hideValidateButton: (() -> Void)?
    var showValidateButton: (() -> Void)?
    var closeContainer: (() -> Void)?
    
    init(
        stateObservable: Observable<ContainerMapAndTitleNavigationState>,
        interaction: ContainerMapAndTitleNavigationInteraction
    ) {
        self.stateObservable = stateObservable
        self.interaction = interaction
    }
    
    func subscribeToObserverState() {
        disposeState = stateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let state = event.element,
                    let actionResponse = state.actionResponse
                else { return }
                
                self.setState(state)
                
                switch actionResponse {
                case .hideValidateButtonActionResponse:
                    self.handleHideValidateButtonActionResponse()
                case .showValidateButtonActionResponse:
                    self.handleShowValidateButtonActionResponse()
                case .closeContainerActionResponse:
                    self.handleCloseContainerActionResponse()
                case .makeProducerSuccessActionResponse:
                    self.handleMakeProducerSuccessActionResponse()
                case .notActionResponse:
                    break
                }
        }
    }
    
    func disposes() {
        _ = Util.runInSchedulerBackground {
            self.disposeState?.dispose()
        }
    }
    
    private func setState(_ state: ContainerMapAndTitleNavigationState) {
        self.state = state
    }
}

extension ContainerMapAndTitleNavigationViewModelImpl {
    func handleValidateButton() {
        interaction.makeProducerAction()
    }
    
    func handleBackButton() {
        interaction.closeContainerAction()
    }
    
    private func handleHideValidateButtonActionResponse() {
        hideValidateButton?()
    }
    
    private func handleShowValidateButtonActionResponse() {
        showValidateButton?()
    }
    
    private func handleCloseContainerActionResponse() {
        interaction.killStateAction()
        closeContainer?()
    }
    
    private func handleMakeProducerSuccessActionResponse() {
        interaction.closeContainerAction()
    }
}

protocol ContainerMapAndTitleNavigationViewModel {
    var hideValidateButton: (() -> Void)? { get set }
    var showValidateButton: (() -> Void)? { get set }
    var closeContainer: (() -> Void)? { get set }
    func subscribeToObserverState()
    func disposes()
    func handleValidateButton()
    func handleBackButton()
}
