//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class CulturalPracticeFormViewModel {
    let culturalPracticeFormObs: Observable<CulturalPracticeFormState>
    
    init(culturalPracticeFormObs: Observable<CulturalPracticeFormState>) {
        self.culturalPracticeFormObs = culturalPracticeFormObs
    }
}
