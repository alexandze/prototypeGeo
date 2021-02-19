//
//  ProducerListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2019-12-29.
//  Copyright © 2019 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

class ProducerListViewModelImpl: ProducerListViewModel {
    
    let producerListInteraction: ProducerListInteraction
    let stateObservable: Observable<ProducerListState>
    var disposableTableViewControllerState: Disposable?
    var showMakeProducerContainer: (() -> Void)?
    var reloadTableViewData: (() -> Void)?
    var state: ProducerListState?
    
    init(
        producerListInteraction: ProducerListInteraction,
        producerListStateObservable: Observable<ProducerListState>
    ) {
        self.producerListInteraction = producerListInteraction
        self.stateObservable = producerListStateObservable
    }
    
    func handlerViewWillAppear() {
        susbcribeToObservableState()
        dispatchGetFarmers(offset: 0, limit: 0)
    }
    
    func handlerViewWillDisappear() {
        disposeToObservableState()
    }
    
    func getNumberRow() -> Int {
        state?.producerList?.count ?? 0
    }
    
    func getNameByIndexPath(_ indexPath: IndexPath) -> String {
        guard let producerList = state?.producerList,
            Util.hasIndexInArray(producerList, index: indexPath.row),
            let firstName = producerList[indexPath.row].firstName?.value,
            let lastName = producerList[indexPath.row].lastName?.value
        else {
            return ""
        }
        
        return "\(firstName) \(lastName)"
    }
    
    private func susbcribeToObservableState() {
        disposableTableViewControllerState = stateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe { [weak self] even in
                guard let state = even.element,
                    let actionResponse = state.actionResponse,
                    let self = self
                    else { return }
                
                self.state = state
                
                switch actionResponse {
                case .getProducerListSuccesActionResponse:
                    self.handleGetProducerListSuccessActionResponse()
                case .saveNewProducerInDatabaseSuccessActionResponse:
                    self.getSaveNewProducerInDatabaseSuccessActionResponse()
                case .notActionResponse:
                    break
                }
        }
    }
    
    private func disposeToObservableState() {
        disposableTableViewControllerState?.dispose()
    }
    
    private func dispatchGetFarmers(offset: Int, limit: Int) {
        producerListInteraction.getProducerListAction(offset: offset, limit: limit)
    }
}

extension ProducerListViewModelImpl {
    func handleAddProducerButton() {
        // TODO dispatch show AddProducer
        showMakeProducerContainer?()
    }
    
    private func handleGetProducerListSuccessActionResponse() {
        reloadTableViewData?()
    }
    
    private func getSaveNewProducerInDatabaseSuccessActionResponse() {
        
    }
}

protocol ProducerListViewModel {
    var showMakeProducerContainer: (() -> Void)? { get set }
    var reloadTableViewData: (() -> Void)? { get set }
    func handlerViewWillAppear()
    func handlerViewWillDisappear()
    func getNumberRow() -> Int
    func getNameByIndexPath(_ indexPath: IndexPath) -> String
}
