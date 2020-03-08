//
//  FieldCuturalPracticeViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class FieldCulturalPraticeViewModelImpl: FieldCulturalPraticeViewModel {

    let fieldCulturalPracticeStateObs: Observable<CulturalPracticeState>
    let fieldCulturalPracticeInteraction: FieldCulturalPracticeInteraction

    init(
        fieldCulturalPracticeStateObs: Observable<CulturalPracticeState>,
        fieldCulturalPracticeInteraction: FieldCulturalPracticeInteraction
    ) {
        self.fieldCulturalPracticeStateObs = fieldCulturalPracticeStateObs
        self.fieldCulturalPracticeInteraction = fieldCulturalPracticeInteraction
    }

}

protocol FieldCulturalPraticeViewModel {

}
