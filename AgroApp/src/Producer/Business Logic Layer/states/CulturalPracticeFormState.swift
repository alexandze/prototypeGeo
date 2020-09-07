//
//  CulturalPracticeState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct CulturalPracticeFormState: Equatable {
    static func == (lhs: CulturalPracticeFormState, rhs: CulturalPracticeFormState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var currentField: Field?
    var sections: [Section<ElementUIData>]?
    var culturalPracticeElementSectionList: [Section<ElementUIData>]?
    var fieldElementSectionList: [Section<ElementUIData>]?
    var title: String?
    var isFinishCompletedLastDoseFumier: Bool?
    var responseAction: ResponseAction?

    enum ResponseAction {
        case selectFieldOnListActionResponse
        case addDoseFumierActionResponse(
            indexPaths: [IndexPath],
            isMaxDoseFumier: Bool,
            isFinishCompletedLastDoseFumier: Bool,
            isCurrrentSectionIsCulturalPractice: Bool
        )

        case updateElementResponse(indexPaths: [IndexPath])

        case selectElementOnListResponse(
            section: Section<ElementUIData>
        )

        case removeDoseFumierResponse(
            indexPathsRemove: [IndexPath],
            indexPathsAdd: [IndexPath],
            isCurrrentSectionIsCulturalPractice: Bool
        )
        
        case showFieldDataSectionListActionResponse(indexPathRemove: [IndexPath], indexPathAdd: [IndexPath])
        case showCulturalPracticeDataSectionListActionResponse(indexPathRemove: [IndexPath], indexPathAdd: [IndexPath])

        case notResponse
    }

    public func changeValues(
        currentField: Field? = nil,
        sections: [Section<ElementUIData>]? = nil,
        culturalPracticeElementSectionList: [Section<ElementUIData>]? = nil,
        fieldElementSectionList: [Section<ElementUIData>]? = nil,
        title: String? = nil,
        isFinishCompletedCurrentContainer: Bool? = nil,
        responseAction: ResponseAction? = nil
    ) -> CulturalPracticeFormState {
        CulturalPracticeFormState(
            uuidState: UUID().uuidString,
            currentField: currentField ?? self.currentField,
            sections: sections ?? self.sections,
            culturalPracticeElementSectionList: culturalPracticeElementSectionList ?? self.culturalPracticeElementSectionList,
            fieldElementSectionList: fieldElementSectionList ?? self.fieldElementSectionList,
            title: title ?? self.title,
            isFinishCompletedLastDoseFumier: isFinishCompletedCurrentContainer ?? self.isFinishCompletedLastDoseFumier,
            responseAction: responseAction ?? self.responseAction
        )
    }
}
