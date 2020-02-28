//
//  FarmerTableViewInteractionsImpl.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
public class FarmerTableViewInteractionsImpl: FarmerTableViewInteractions {
    
    // MARK: - Properties
    let actionDispatcher: ActionDispatcher
    
    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    public func getFamers(offset: Int, limit: Int) {
        self.actionDispatcher.dispatch(GetFamersAction(offset: offset, limit: limit))
    }
    
    public func goToFarmerAddViewController() {
        self.actionDispatcher.dispatch(NavigationAction(url: FarmerRouter.URL_FARMER_TABLE_VIEW_TO_FARMER_CREATE, data: nil))
    }
}
