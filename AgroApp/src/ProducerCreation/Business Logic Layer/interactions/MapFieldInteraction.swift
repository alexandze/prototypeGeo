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

    public func getAllField() {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.GetAllField())
        }
    }

    func selectedField(field: FieldType) {
        let selectedFieldOnMapAction = MapFieldAction.SelectedFieldOnMapAction(fieldType: field)

       _ =  Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(selectedFieldOnMapAction)
        }
    }

    func deselectedField(field: FieldType) {
        let deselectedFieldOnMapAction = MapFieldAction.DeselectedFieldOnMapAction(fieldType: field)

        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(deselectedFieldOnMapAction)
        }

    }

}

protocol MapFieldInteraction {
    func getAllField()
    func selectedField(field: FieldType)
    func deselectedField(field: FieldType)
}
