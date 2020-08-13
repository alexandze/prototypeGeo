//
//  HandlerRemoveFieldAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

class HandlerRemoveFieldAction: HandlerReducer {

    func handle(action: FieldListAction.RemoveFieldAction, _ state: FieldListState) -> FieldListState {
        let util = UtilHandlerRemoveFieldAction(
            indexPathFieldRemoveFromAction: action.indexPath,
            state: state
        )

        return (
            removeField(util:) >>>
                newState(util:)
            )(util) ?? state.changeValue(subAction: .notResponse)
    }

    private func removeField(util: UtilHandlerRemoveFieldAction?) -> UtilHandlerRemoveFieldAction? {
        guard var fieldListFromState = util?.state.fieldList,
            var newUtil = util,
            fieldListFromState.indices.contains(newUtil.indexPathFieldRemoveFromAction.row)
            else { return nil }

        newUtil.fieldRemoved =
            fieldListFromState.remove(at: newUtil.indexPathFieldRemoveFromAction.row)

        newUtil.newFieldList = fieldListFromState
        return newUtil
    }

    private func newState(util: UtilHandlerRemoveFieldAction?) -> FieldListState? {
        guard let newUtil = util,
            let newFieldList = newUtil.newFieldList,
            let fieldRemoved = newUtil.fieldRemoved
            else { return nil }

        return newUtil.state.changeValue(
            fieldList: newFieldList,
            subAction: .removeFieldResponse(
                indexPathFieldRemoved: newUtil.indexPathFieldRemoveFromAction,
                fieldRemoved: fieldRemoved
            )
        )
    }

}

private struct UtilHandlerRemoveFieldAction {
    var indexPathFieldRemoveFromAction: IndexPath
    var state: FieldListState
    var newFieldList: [Field]?
    var fieldRemoved: Field?
}
