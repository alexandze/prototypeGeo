//
//  StoreExtension].swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

extension Store {
    public func makeObservable<SelectedState>(transform: @escaping (Subscription<State>) -> Subscription<SelectedState>) -> Observable<SelectedState> {
        let onRxSubscribe = { [weak self] (rxObserver: AnyObserver<SelectedState>) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            
            let subscriberProxy = StoreSubscriberProxy<SelectedState>(rxObserver: rxObserver)
            self.subscribe(subscriberProxy, transform: transform)
            let disposable = self.makeUnSubscribeDisposable(subscriber: subscriberProxy)
            return disposable
        }
        
        return Observable.create(onRxSubscribe)
    }
    
    public func makeObservable() -> Observable<State> {
        let onRxSubscribe = { [weak self] (rxObserver: AnyObserver<State>) -> Disposable in
            guard let self = self else {
                return Disposables.create()
            }
            
            let subscriberProxy = StoreSubscriberProxy<State>(rxObserver: rxObserver)
            self.subscribe(subscriberProxy)
            let disposable = self.makeUnSubscribeDisposable(subscriber: subscriberProxy)
            
            return disposable
        }
        
        return Observable.create(onRxSubscribe)
    }
    
    private func makeUnSubscribeDisposable<S: StoreSubscriber>(subscriber: S) -> Disposable {
        return Disposables.create { [weak self] in
            self?.unsubscribe(subscriber)
        }
    }
}
