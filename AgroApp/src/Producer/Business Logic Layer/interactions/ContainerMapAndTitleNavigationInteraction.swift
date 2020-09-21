//
//  ContainerMapAndTitleNavigationInteraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class ContainerMapAndTitleNavigationInteractionImpl: ContainerMapAndTitleNavigationInteraction {
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher

    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    func makeProducerAction() {
        let action = ContainerMapAndTitleNavigationAction.MakeProducerAction()
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }
    
    func closeContainerAction() {
        let action = ContainerMapAndTitleNavigationAction.CloseContainerAction()
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }
    
    func killStateAction() {
        let action = ContainerMapAndTitleNavigationAction.KillStateAction()
        Util.dispatchActionInSchedulerReSwift(action, actionDispatcher: actionDispatcher)
    }
}

protocol ContainerMapAndTitleNavigationInteraction {
    func makeProducerAction()
    func closeContainerAction()
    func killStateAction()
}
