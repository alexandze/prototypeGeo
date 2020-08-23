//
//  CulturalPracticeFactory.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class CulturalPracticeFactoryImpl: CulturalPracticeFactory {
    let culturalPracticeUpdateFactory: CulturalPracticeUpdateFactory
    let culturalPracticeRemoveFactory: CulturalPracticeRemoveFactory
    
    init(
        culturalPracticeUpdateFactory: CulturalPracticeUpdateFactory = CulturalPracticeUpdateFactoryImpl(),
        culturalPracticeRemoveFactory: CulturalPracticeRemoveFactory = CulturalPracticeRemoveFactoryImpl()
    ) {
        self.culturalPracticeUpdateFactory = culturalPracticeUpdateFactory
        self.culturalPracticeRemoveFactory = culturalPracticeRemoveFactory
    }
    
    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice? = nil, _ elementUIData: ElementUIData) -> CulturalPractice? {
        culturalPracticeUpdateFactory.makeCulturalPracticeByUpdate(culturalPractice, elementUIData)
    }
    
    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice {
        culturalPracticeRemoveFactory.makeCulturalPraticeByRemove(culturalPractice, section: section)
    }
    
}

protocol CulturalPracticeFactory {
    func makeCulturalPracticeByUpdate(_ culturalPractice: CulturalPractice?, _ elementUIData: ElementUIData) -> CulturalPractice?
    func makeCulturalPraticeByRemove(_ culturalPractice: CulturalPractice, section: Section<ElementUIData>) -> CulturalPractice
}
