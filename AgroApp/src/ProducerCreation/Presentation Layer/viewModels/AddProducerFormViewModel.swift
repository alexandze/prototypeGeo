//
//  AddProducerFormViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class AddProducerFormViewModelImpl: AddProducerFormViewModel {
    let stateObservable: Observable<AddProducerFormState>
    let interaction: AddProducerFormInteraction
    // TODO mettre view controller a nil dans le dispose
    var viewController: SettingViewController<AddProducerFormView>?
    var disposableStateObserver: Disposable?
    var state: AddProducerFormState?

    init(
        addProducerFormStateObservable: Observable<AddProducerFormState>,
        addProducerFormInteraction: AddProducerFormInteraction
    ) {
        self.stateObservable = addProducerFormStateObservable
        self.interaction = addProducerFormInteraction
    }

    func subscribeToStateObservable() {
        self.disposableStateObserver = stateObservable
            .observeOn(Util.getSchedulerMain())
            .subscribe { event in
                guard let state = event.element,
                    let responseAction = state.responseAction
                    else { return }

                self.setValues(addProducerFormState: state)

                switch responseAction {
                case .notResponse:
                    break
                }

        }
    }

    func dispose() {
        viewController = nil

        _ = Util.runInSchedulerBackground {
            self.disposableStateObserver?.dispose()
        }
    }

    private func setValues(addProducerFormState: AddProducerFormState) {
        self.state = addProducerFormState
    }

    func configView() {
        self.viewController?.setBackgroundColor(Util.getBackgroundColor())
        self.viewController?.setAlpha(Util.getAlphaValue())
        self.viewController?.setIsModalInPresentation(true)
    }
}

protocol AddProducerFormViewModel {
    var viewController: SettingViewController<AddProducerFormView>? {get set}
    func configView()
    func subscribeToStateObservable()
    func dispose()
}
