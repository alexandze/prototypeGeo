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

    func didSelectedFieldAction(field: Field?) {
        guard let field = field else { return }
        let selectedFieldOnMapAction = MapFieldAction.DidSelectedFieldOnMapAction(field: field)

        _ =  Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(selectedFieldOnMapAction)
        }
    }

    func willDeselectedFieldOnMapAction(idField: Int?) {
        guard let idField = idField else { return }
        let willDeselectFieldOnMapAction = MapFieldAction.WillDeselectFieldOnMapAction(idField: idField)

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

    func willSelectedFieldOnMapAction(idField: Int) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.WillSelectedFieldOnMapAction(idField: idField))
        }
    }

    func didDeselectFieldOnMapAction(field: Field) {
        _ = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(MapFieldAction.DidDelectFieldOnMapAction(field: field))
        }
    }
}

protocol MapFieldInteraction {
    func getAllFieldAction()
    func didSelectedFieldAction(field: Field?)
    func willDeselectedFieldOnMapAction(idField: Int?)
    func getFieldSuccessAction(_ fieldDictionnary: [Int: Field])
    func getFieldErrorAction(error: Error)
    func willSelectedFieldOnMapAction(idField: Int)
    func didDeselectFieldOnMapAction(field: Field)
}
