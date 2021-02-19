//
//  MapFieldInteraction.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

public class MapFieldInteractionImpl: MapFieldInteraction {

    // MARK: - Properties
    let actionDispatcher: ActionDispatcher

    // MARK: - Methods
    init(actionDispatcher: ActionDispatcher) {
        self.actionDispatcher = actionDispatcher
    }

    public func getAllFieldAction() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.GetAllFieldAction())
        }
    }

    func willDeselectedFieldOnMapAction(field: Field?) {
        guard let field = field else { return }
        let willDeselectFieldOnMapAction = MapFieldAction.WillDeselectFieldOnMapAction(field: field)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(willDeselectFieldOnMapAction)
        }
    }

    func getFieldSuccessAction(_ fieldDictionnary: [Int: Field]) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                MapFieldAction.GetAllFieldSuccessAction(fieldDictionnary: fieldDictionnary)
            )
        }
    }

    func getFieldErrorAction(error: Error) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.GetAllFieldErrorAction(error: error))
        }
    }

    func willSelectedFieldOnMapAction(field: Field?) {
        guard let field = field else {
            return
        }

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.WillSelectedFieldOnMapAction(field: field))
        }
    }
}

protocol MapFieldInteraction {
    func getAllFieldAction()
    func willDeselectedFieldOnMapAction(field: Field?)
    func getFieldSuccessAction(_ fieldDictionnary: [Int: Field])
    func getFieldErrorAction(error: Error)
    func willSelectedFieldOnMapAction(field: Field?)
}
