//
//  FieldDetailsService.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-22.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class FieldDetailsServiceImpl: FieldDetailsService {
    let fieldDetailsFactory: FieldDetailsFactory
    
    init(fieldDetailsFactory: FieldDetailsFactory = FieldDetailsFactoryImpl()) {
        self.fieldDetailsFactory = fieldDetailsFactory
    }
    
    
    /// Make section elementUIData list  by cultural Practice. If there is value like Avaloir, the section elementUIData content value.
    /// If cultural practice is nil,  he is make section elementUIData.value == nil
    /// - Parameter culturalPracticeOp: cultural practice optionnel
    /// - Returns: Section list
    func makeSectionListElementUIData(_ culturalPracticeOp: CulturalPractice?) -> [Section<ElementUIData>] {
        fieldDetailsFactory.makeSectionListElementUIData(culturalPracticeOp)
    }
    
    
    /// Reset section who typeSection is ELEMENT_UI_LIST_DATA.
    /// After remove cutural practice dose fumier, you should call this function for reset section who content dose fumier
    /// - Parameters:
    ///   - culturalPractice: new cultural practice after remove dose fumier
    ///   - sectionList: current section list
    /// - Returns: New sections whit dose fumier update
    func makeSectionListElementUIDataByResetSectionElementUIListData(
        _ culturalPractice: CulturalPractice,
        _ sectionList: [Section<ElementUIData>]
    ) -> [Section<ElementUIData>] {
        fieldDetailsFactory.makeSectionListElementUIDataByResetSectionElementUIListData(
            culturalPractice,
            sectionList
        )
    }
}

protocol FieldDetailsService {
    func makeSectionListElementUIData(_ culturalPracticeOp: CulturalPractice?) -> [Section<ElementUIData>]
    
    func makeSectionListElementUIDataByResetSectionElementUIListData(
        _ culturalPractice: CulturalPractice,
        _ sectionList: [Section<ElementUIData>]
    ) -> [Section<ElementUIData>]
}
