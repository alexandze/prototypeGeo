//
//  SelectFormCulturalPracticeInterraction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-25.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class SelectFormCulturalPracticeInterractionImpl: SelectFormCulturalPracticeInterraction {
    let actionDispatcher: ActionDispatcher
    
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }
    
    func closeSelectFormWithSaveAction(indexSelected: Int) {
        _ = Util.runInSchedulerBackground { [weak self] in
            self?.actionDispatcher.dispatch(
                SelectFormCulturalPracticeAction.CloseSelectFormWithSaveAction(indexSelected: indexSelected)
            )
        }
    }
}

protocol SelectFormCulturalPracticeInterraction {
    func closeSelectFormWithSaveAction(indexSelected: Int)
}
