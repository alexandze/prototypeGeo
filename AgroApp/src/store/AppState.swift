//
//  AppState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var producerListState: ProducerListState
    var mapFieldState: MapFieldState
    var fieldListState: FieldListState
    var culturalPracticeState: CulturalPracticeFormState
    var selectFormCulturalPracticeState: SelectFormCulturalPracticeState
    var inputFormCulturalPracticeState: InputFormCulturalPracticeState
    var containerFormCulturalPracticeState: ContainerFormCulturalPracticeState
    var containerTitleNavigationState: ContainerTitleNavigationState
    var addProducerFormState: AddProducerFormState
    var loginState: LoginState
    var containerMapAndTitleNavigationState: ContainerMapAndTitleNavigationState
}
