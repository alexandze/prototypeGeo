//
//  HandlerUpdateFieldAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

class HandlerUpdateFieldAction: HandlerReducer {

    func handle(action: FieldListAction.UpdateFieldAction, _ state: FieldListState) -> FieldListState {
        let util = UtilHandlerUpdateFieldAction(fieldFromAction: action.field, state: state)

        return (
            findIndexOfFieldForUpdate >>>
            updateFieldInList >>>
            newState
            )(util) ?? state.changeValue(subAction: .notResponse)
    }

    private func findIndexOfFieldForUpdate(util: UtilHandlerUpdateFieldAction?) -> UtilHandlerUpdateFieldAction? {
        guard let fieldListFromState = util?.state.fieldList,
        !fieldListFromState.isEmpty,
        var newUtil = util
            else { return nil }

        let indexFieldFind = fieldListFromState.firstIndex { $0.id == newUtil.fieldFromAction.id }
        guard let indexFieldFindUw = indexFieldFind else { return nil }
        newUtil.indexFieldForUpdate = indexFieldFindUw
        return newUtil
    }

    private func updateFieldInList(util: UtilHandlerUpdateFieldAction?) -> UtilHandlerUpdateFieldAction? {
        guard let indexFind = util?.indexFieldForUpdate,
            var fieldListFromState = util?.state.fieldList,
            var newUtil = util
            else { return nil }

        fieldListFromState[indexFind] = newUtil.fieldFromAction
        newUtil.newFieldList = fieldListFromState
        return newUtil
    }

    private func newState(util: UtilHandlerUpdateFieldAction?) -> FieldListState? {
        guard let newFieldList = util?.newFieldList,
        let state = util?.state
            else { return nil }

        return state
            .changeValue(fieldList: newFieldList, subAction: .updateFieldSuccess)
    }
}

private struct UtilHandlerUpdateFieldAction {
    var fieldFromAction: Field
    var state: FieldListState
    var newFieldList: [Field]?
    var indexFieldForUpdate: Int?
}
