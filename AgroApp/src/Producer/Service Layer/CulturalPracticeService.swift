//
//  CulturalPracticeService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class CulturalPracticeServiceImpl: CulturalPracticeService {

    let culturalPracticeRemoveFactory: CulturalPracticeRemoveFactory
    let culturalPracticeUpdateFactory: CulturalPracticeUpdateFactory
    init(
        culturalPracticeRemoveFactory: CulturalPracticeRemoveFactory = CulturalPracticeRemoveFactoryImpl(),
        culturalPracticeUpdateFactory: CulturalPracticeUpdateFactory = CulturalPracticeUpdateFactoryImpl()
    ) {
        self.culturalPracticeRemoveFactory = culturalPracticeRemoveFactory
        self.culturalPracticeUpdateFactory = culturalPracticeUpdateFactory
    }

    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice {
        culturalPracticeRemoveFactory.makeCulturalPraticeByRemove(culturalPractice, section: section)
    }

    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice, _ section: Section<ElementUIData>) -> CulturalPractice? {
        culturalPracticeUpdateFactory.makeCulturalPracticeByUpdate(culturalPractice, section)
    }
}

protocol CulturalPracticeService {
    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice, _ section: Section<ElementUIData>) -> CulturalPractice?
    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice
}
