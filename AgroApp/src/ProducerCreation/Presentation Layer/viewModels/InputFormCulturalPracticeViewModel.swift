//
//  InputFormCulturalPracticeViewModel.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import SwiftUI

class InputFormCulturalPracticeViewModelImpl: InputFormCulturalPracticeViewModel {
    let stateObserver: Observable<InputFormCulturalPracticeState>
    let actionDispatcher: ActionDispatcher
    let viewState = ViewState()

    init(
        stateObserver: Observable<InputFormCulturalPracticeState>,
        actionDispatcher: ActionDispatcher
        ) {
        self.stateObserver = stateObserver
        self.actionDispatcher = actionDispatcher
    }

    class ViewState {
        @State var inputValue: String = ""
        @State var inputTitle: String = ""
    }
}

protocol InputFormCulturalPracticeViewModel {
    var viewState: InputFormCulturalPracticeViewModelImpl.ViewState {get}
}
