//
//  CulturalPracticeState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
struct CulturalPracticeState: Equatable {
    static func == (lhs: CulturalPracticeState, rhs: CulturalPracticeState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var currentField: FieldType?
    var sections: [Section<CulturalPracticeElementProtocol>]?
    var subAction: CulturalPracticeSubAction?

    public func changeValues(
        currentField: FieldType? = nil,
        sections: [Section<CulturalPracticeElementProtocol>]? = nil,
        subAction: CulturalPracticeSubAction? = nil
    ) -> CulturalPracticeState {
        CulturalPracticeState(
            uuidState: UUID().uuidString,
            currentField: currentField ?? self.currentField,
            sections: sections ?? self.sections,
            subAction: subAction ?? self.subAction
        )
    }
}

enum CulturalPracticeSubAction {
    case reloadData
    case insertRows(indexPath: [IndexPath])
    case deletedRows(indexPath: [IndexPath])
    case updateRows(indexPath: [IndexPath])
    case selectElementOnList(
        culturalPracticeElement: CulturalPracticeElementProtocol,
        fieldType: FieldType
    )

    case canNotSelectElementOnList(culturalPracticeElement: CulturalPracticeElementProtocol)

}
