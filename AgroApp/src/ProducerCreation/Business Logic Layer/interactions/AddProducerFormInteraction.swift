//
//  AddProducerFormInteraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class AddProducerFormInteractionImpl: AddProducerFormInteraction {
    private let actionDispatcher: ActionDispatcher

    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    func getListElementUIDataWithoutValueAction() {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                AddProducerFormAction.GetListElementUIDataWithoutValueAction()
            )
        }
    }

}

protocol AddProducerFormInteraction {
    func getListElementUIDataWithoutValueAction()
}
