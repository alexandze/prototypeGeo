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
    
    func dispatchGetFarmers(offset: Int, limit: Int) {
        producerListInteraction.getFamers(offset: offset, limit: limit)
    }
    
    func susbcribeToObservableState() {
        self.disposableTableViewControllerState = state
            .observeOn(Util.getSchedulerMain())
            .subscribe { even in
                guard let state = even.element else { return }
                
        }
    }

    func disposeToObservableState() {
        self.disposableTableViewControllerState?.dispose()
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
    func susbcribeToObservableState()
    func disposeToObservableState()
}
