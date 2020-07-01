//
//  FieldListInteractionImpl.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldListInteractionImpl: FieldListInteraction {
    let actionDispatcher: ActionDispatcher

    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    public func setCurrentField(field: FieldType) {
        //TODO: set current field
    }
}

protocol FieldListInteraction {
    func setCurrentField(field: FieldType)
}
