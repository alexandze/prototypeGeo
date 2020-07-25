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
    var subAction: CulturalPracticeSubAction?
    var title: String?
    var isFinishCompletedCurrentContainer: Bool?

    public func changeValues(
        currentField: Field? = nil,
        sections: [Section<CulturalPracticeElementProtocol>]? = nil,
        subAction: CulturalPracticeSubAction? = nil,
        title: String? = nil,
        isFinishCompletedCurrentContainer: Bool? = nil
    ) -> CulturalPracticeFormState {
        CulturalPracticeFormState(
            uuidState: UUID().uuidString,
            currentField: currentField ?? self.currentField,
            sections: sections ?? self.sections,
            subAction: subAction ?? self.subAction,
            title: title ?? self.title,
            isFinishCompletedCurrentContainer: isFinishCompletedCurrentContainer ?? self.isFinishCompletedCurrentContainer
        )
    }
}

enum CulturalPracticeSubAction {
    case reloadData
    case insertRows(indexPath: [IndexPath])
    case deletedRows(indexPath: [IndexPath])
    case updateRows(indexPath: [IndexPath])
    case willSelectElementOnList(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        field: Field
    )

    case canNotSelectElementOnList(culturalPracticeElement: CulturalPracticeElementProtocol)

}
