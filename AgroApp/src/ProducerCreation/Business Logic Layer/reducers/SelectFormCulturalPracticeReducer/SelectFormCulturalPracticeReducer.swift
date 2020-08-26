//
//  SelectFormCulturalPracticeReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func selectFormCulturalPracticeReducer(action: Action, state: SelectFormCulturalPracticeState?) -> SelectFormCulturalPracticeState {
        let state = state ?? SelectFormCulturalPracticeState(uuidState: UUID().uuidString)

        switch action {
        case let selectedElementOnListAction as SelectFormCulturalPracticeAction.SelectElementSelectedOnListAction:
            return SelectFormCulturalPracticeHandlerReducer
                .HandlerSelectElementSelectedOnListAction().handle(action: selectedElementOnListAction, state)
        default:
            break
        }

        return state
    }
}

class SelectFormCulturalPracticeHandlerReducer { }
