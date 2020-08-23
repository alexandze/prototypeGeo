//
//  HandlerSelectFieldOnListAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

extension CulturalPracticeFormReducerHandler {
    
    class HandlerSelectFieldOnListAction: HandlerReducer {
        let fieldDetailsFactory: FieldDetailsFactory
        
        func handle(action: FieldListAction.SelectFieldOnListAction, _ state: CulturalPracticeFormState) -> CulturalPracticeFormState {
            
        }
    }
    
    private struct UtilHandlerSelectFieldOnListAction {
        var state: CulturalPracticeFormState
        var fieldSelected: Field
    }
}


