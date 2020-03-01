//
//  MapFieldInteraction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

public class MapFieldInteractionImpl: MapFieldInteraction {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    
    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    public func getAllField() {
        self.actionDispatcher.dispatch(MapFieldAction.GetAllField())
    }
    
}


protocol MapFieldInteraction {
    func getAllField()
}
