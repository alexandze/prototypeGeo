//
//  Reducers.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct Reducers {
    public static func appReducer(action: Action, state: AppState?) -> AppState {
        return AppState(
            farmerState: Reducers.farmerReducer(action: action, state: state?.farmerState),
            mapFieldState: Reducers.mapFieldReducer(action: action, state: state?.mapFieldState),
            fieldListState: Reducers.fieldListReducer(action: action, state: state?.fieldListState),
            culturalPracticeState: Reducers.culturalPracticeFormReducer(action: action, state: state?.culturalPracticeState),
            selectFormCulturalPracticeState: Reducers.selectFormCulturalPracticeReducer(action: action, state: state?.selectFormCulturalPracticeState),
            inputFormCulturalPracticeState: Reducers.inputFormCulturalPracticeReducer(action: action, state: state?.inputFormCulturalPracticeState),
            containerFormCulturalPracticeState: Reducers.containerFormCulturalPracticeReducer(action: action, state: state?.containerFormCulturalPracticeState),
            containerTitleNavigationState: Reducers.containerTitleNavigationReducer(action: action, state: state?.containerTitleNavigationState),
            addProducerFormState: Reducers.addProducerFormReducer(action: action, state: state?.addProducerFormState),
            loginState: Reducers.loginReducer(action: action, state: state?.loginState)
        )
    }
}
