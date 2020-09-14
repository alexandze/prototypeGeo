//
//  FieldListState.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct FieldListState: Equatable {
    static func == (lhs: FieldListState, rhs: FieldListState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var fieldList: [Field]?
    var currentField: Field?
    var indexForRemove: Int?
    var subAction: SubAction? = .initFieldList
    var title: String = "Liste des parcelles choisies"
    var isAppear: Bool?
    var indexForUpdate: Int?
    var nimSelectValue: NimSelectValue?
    
    // TODO renomer en response
    enum SubAction {
        case selectedFieldOnMapActionSuccess
        case deselectedFieldOnMapActionSuccess
        case willSelectFieldOnListActionSucccess
        case initFieldList
        case isAppearActionSuccess
        case updateFieldSuccess
        case removeFieldResponse(indexPathFieldRemoved: IndexPath, fieldRemoved: Field)
        case initNimSelectValueActionResponse
        case checkIfAllFieldIsValidActionResponse(isAllFieldValid: Bool)
        case notResponse
    }

    func changeValue(
        fieldList: [Field]? = nil,
        currentField: Field? = nil,
        indexForRemove: Int? = nil,
        subAction: SubAction? = nil,
        title: String? = nil,
        isAppear: Bool? = nil,
        indexForUpdate: Int? = nil,
        nimSelectValue: NimSelectValue? = nil
    ) -> FieldListState {
        FieldListState(
            uuidState: UUID().uuidString,
            fieldList: fieldList ?? self.fieldList,
            currentField: currentField ?? self.currentField,
            indexForRemove: indexForRemove ?? self.indexForRemove,
            subAction: subAction ?? self.subAction,
            title: title ?? self.title,
            isAppear: isAppear ?? self.isAppear,
            indexForUpdate: indexForUpdate ?? self.indexForUpdate,
            nimSelectValue: nimSelectValue ?? self.nimSelectValue
        )
    }
}
