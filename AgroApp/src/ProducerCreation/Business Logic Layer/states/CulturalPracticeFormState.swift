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
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var title: String?
    var isFinishCompletedCurrentContainer: Bool?
    var responseAction: ResponseAction?

    enum ResponseAction {
        case reloadAllListElementResponse
        case insertContainerElementResponse(indexPath: [IndexPath])
        case updateElementResponse(indexPath: [IndexPath])

        case willSelectElementOnListResponse(
            culturalPracticeElement: CulturalPracticeElementProtocol,
            field: Field
        )

        case removeDoseFumierResponse(
            indexPathsRemove: [IndexPath],
            indexPathsAdd: [IndexPath]?
        )

        case canNotSelectElementOnListResponse(culturalPracticeElement: CulturalPracticeElementProtocol)
        case notResponse
    }

    public func changeValues(
        currentField: Field? = nil,
        sections: [Section<CulturalPracticeElementProtocol>]? = nil,
        title: String? = nil,
        isFinishCompletedCurrentContainer: Bool? = nil,
        responseAction: ResponseAction? = nil
    ) -> CulturalPracticeFormState {
        CulturalPracticeFormState(
            uuidState: UUID().uuidString,
            currentField: currentField ?? self.currentField,
            sections: sections ?? self.sections,
            title: title ?? self.title,
            isFinishCompletedCurrentContainer: isFinishCompletedCurrentContainer ?? self.isFinishCompletedCurrentContainer,
            responseAction: responseAction ?? self.responseAction
        )
    }
}
