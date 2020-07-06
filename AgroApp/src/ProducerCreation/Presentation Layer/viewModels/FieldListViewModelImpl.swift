//
//  FieldListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class FieldListViewModelImpl: FieldListViewModel {

    let fieldListStateObs: Observable<FieldListState>
    let actionDispatcher: ActionDispatcher
    var disposableFieldListState: Disposable?
    var fieldList: [FieldType] = []
    var tableView: UITableView?
    var viewController: UIViewController?

    init(
        fieldListStateObs: Observable<FieldListState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.fieldListStateObs = fieldListStateObs
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToObservableFieldListState() {
        self.disposableFieldListState = fieldListStateObs
            .observeOn(MainScheduler.instance)
            .subscribe {
                if let state = $0.element {
                    if !state.isForRemove {
                        return self.insertRow(fieldListState: state)
                    }

                    self.deletedRow(fieldListState: state)
                }
        }
    }

    func dispose() {
        self.disposableFieldListState?.dispose()
    }

    func insertRow(fieldListState: FieldListState) {
        self.fieldList = fieldListState.fieldList
        tableView?.beginUpdates()
        self.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tableView?.endUpdates()
    }

    func deletedRow(fieldListState: FieldListState) {
        self.fieldList = fieldListState.fieldList
        let indexDeleted = fieldListState.indexForRemove
        tableView?.beginUpdates()
        self.tableView?.deleteRows(at: [IndexPath(row: indexDeleted, section: 0)], with: .top)
        tableView?.endUpdates()
    }

    func setTableView(tableView: UITableView) {
        self.tableView = tableView
    }

    public func handle(didSelectRowAt indexPath: IndexPath) {
        let currentFieldSelected = fieldList[indexPath.row]
        let action = CulturalPracticeFormAction.SelectedFieldOnListAction(fieldType: currentFieldSelected)
        actionDispatcher.dispatch(action)

        let appDelegate = viewController!.getAppDelegate()
        appDelegate.map {
            viewController?.navigationController?.pushViewController($0.appDependencyContainer.processInitCulturalPracticeViewController(), animated: true)
        }
    }
}

protocol FieldListViewModel {
    func subscribeToObservableFieldListState()
    func dispose()
    func setTableView(tableView: UITableView)
    var fieldList: [FieldType] {get}
    var viewController: UIViewController? {get set}
    func handle(didSelectRowAt indexPath: IndexPath)
}
