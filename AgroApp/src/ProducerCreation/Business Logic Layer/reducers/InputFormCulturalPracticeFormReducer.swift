//
//  inputFormCulturalPracticeFormReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func inputFormCulturalPracticeReducer(action: Action, state: InputFormCulturalPracticeState?) -> InputFormCulturalPracticeState {
        var state = state ?? InputFormCulturalPracticeState(uuidState: UUID().uuidString)

        return state
    }
}
