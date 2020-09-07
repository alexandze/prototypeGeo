//
//  ContainerTitleNavigationState.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation

struct ContainerTitleNavigationState: Equatable {

    static func == (lhs: ContainerTitleNavigationState, rhs: ContainerTitleNavigationState) -> Bool {
        lhs.uuidState == rhs.uuidState
    }

    var uuidState: String
    var title: String?
    var subAction: SubAction?
    var currentViewController: CurrentViewControllerInNavigation?

    // TODO responseAction
    enum SubAction {
        case setTitleActionSuccess
        case setCurrentViewControllerInNavigationActionSuccess
        case hideButttonActionSuccess
        case printButtonActionSuccess
        case backActionSuccess
    }

    enum CurrentViewControllerInNavigation {
        case fieldList
        case culturalPracticeForm
        case addProducerForm
    }

    func changeValue(
        title: String? = nil,
        subAction: SubAction? = nil,
        currentViewController: CurrentViewControllerInNavigation? = nil
    ) -> ContainerTitleNavigationState {
        ContainerTitleNavigationState(
            uuidState: UUID().uuidString,
            title: title ?? self.title,
            subAction: subAction ?? self.subAction,
            currentViewController: currentViewController ?? self.currentViewController
        )
    }
}
