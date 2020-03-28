//
//  CulturalPracticeFormReducer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func culturalPracticeFormReducer(action: Action, state: CulturalPracticeFormState?) -> CulturalPracticeFormState {
        let state = state ?? CulturalPracticeFormState(uuidState: UUID().uuidString)
        
        switch action {
        case let selectedElementOnList as CulturalPracticeFormAction.SelectedElementOnList:
            return CulturalPracticeFormReducerHandler.handle(selectedElementOnList: selectedElementOnList)
        default:
            break
        }
        
        return state
    }
}

class CulturalPracticeFormReducerHandler {
    static func handle(selectedElementOnList: CulturalPracticeFormAction.SelectedElementOnList) -> CulturalPracticeFormState {
        CulturalPracticeFormState(uuidState: UUID().uuidString, culturalPraticeElement: selectedElementOnList.culturalPracticeElement)
    }
}
