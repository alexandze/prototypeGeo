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
    let state: Observable<ProducerListState>
    var disposableTableViewControllerState: Disposable?
    var showMakeProducerContainer: (() -> Void)?

    init(
        producerListInteraction: ProducerListInteraction,
        producerListStateObservable: Observable<ProducerListState>
    ) {
        self.producerListInteraction = producerListInteraction
        self.state = producerListStateObservable
    }
    
    func handlerViewWillAppear() {
        dispatchGetFarmers(offset: 0, limit: 0)
        susbcribeToObservableState()
    }
    
    func handlerViewWillDisappear() {
        disposeToObservableState()
    }
    
    private func susbcribeToObservableState() {
        disposableTableViewControllerState = state
            .observeOn(Util.getSchedulerMain())
            .subscribe { even in
                guard let state = even.element else { return }
                
        }
    }
    
    private func disposeToObservableState() {
        disposableTableViewControllerState?.dispose()
    }
    
    private func dispatchGetFarmers(offset: Int, limit: Int) {
        producerListInteraction.getFamers(offset: offset, limit: limit)
    }
}

extension ProducerListViewModelImpl {
    func handleAddProducerButton() {
        // TODO dispatch show AddProducer
        showMakeProducerContainer?()
    }
}

protocol ProducerListViewModel {
    var showMakeProducerContainer: (() -> Void)? { get set }
    func handlerViewWillAppear()
    func handlerViewWillDisappear()
}
