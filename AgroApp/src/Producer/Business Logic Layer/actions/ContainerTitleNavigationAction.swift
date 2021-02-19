//
//  ContainerTitleNavigationAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ContainerTitleNavigationAction {
    struct HideCloseButtonAction: Action {}

    struct PrintCloseButtonAction: Action { }

    struct SetTitleAction: Action {
        var title: String
    }

    struct BackAction: Action { }

    struct SetCurrentViewControllerAction: Action {
        var currentViewControllerInNavigation: ContainerTitleNavigationState.CurrentViewControllerInNavigation
    }
}
