//
//  FieldListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class FieldListViewModelImpl: FieldListViewModel {
    
    let fieldListState$: Observable<FieldListState>
    let fieldListInteraction: FieldListInteraction
    var disposableFieldListState: Disposable?
    var fieldList: [FieldType] = []
    var tableView: UITableView?
    
    init(
        fieldListState$: Observable<FieldListState>,
        fieldListInteraction: FieldListInteraction
    ) {
        self.fieldListState$ = fieldListState$
        self.fieldListInteraction = fieldListInteraction
    }
    
    func subscribeToObservableFieldListState() {
        self.disposableFieldListState = fieldListState$
            .observeOn(MainScheduler.instance)
            .subscribe {
                if let state = $0.element{
                    if !state.isForRemove  {
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
    
    
}

protocol FieldListViewModel {
    func subscribeToObservableFieldListState()
    func dispose()
    func setTableView(tableView: UITableView)
    var fieldList: [FieldType] {get}
}
