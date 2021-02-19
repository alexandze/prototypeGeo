//
//  ProducerListInteraction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

public class ProducerListInteractionImpl: ProducerListInteraction {

    // MARK: - Properties
    let actionDispatcher: ActionDispatcher

    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    func getProducerListAction(offset: Int, limit: Int) {
        Util.dispatchActionInSchedulerReSwift(ProducerListAction.GetProducerListAction(), actionDispatcher: actionDispatcher)
    }
}

protocol ProducerListInteraction {
    func getProducerListAction(offset: Int, limit: Int)
}
