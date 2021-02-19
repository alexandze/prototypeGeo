//
//  ContainerTitleNavigationReducer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-16.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

extension Reducers {
    public static func containerTitleNavigationReducer(action: Action, state: ContainerTitleNavigationState?) -> ContainerTitleNavigationState {
        let state = state ?? ContainerTitleNavigationState(uuidState: UUID().uuidString)

        switch action {
        case let action as ContainerTitleNavigationAction.HideCloseButtonAction:
            return ContainerTitleNavigationHandler().handle(hideCloseButtonAction: action, state)
        case let action as ContainerTitleNavigationAction.PrintCloseButtonAction:
            return ContainerTitleNavigationHandler().handle(printCloseButtonAction: action, state)
        case let action as ContainerTitleNavigationAction.SetTitleAction:
            return ContainerTitleNavigationHandler().handle(setTitleAction: action, state)
        case let action as ContainerTitleNavigationAction.BackAction:
            return ContainerTitleNavigationHandler().handle(backAction: action, state)
        case let action as ContainerTitleNavigationAction.SetCurrentViewControllerAction:
            return ContainerTitleNavigationHandler().handle(setCurrentViewControllerAction: action, state)
        case _ as ContainerMapAndTitleNavigationAction.KillStateAction:
            return state.reset()
        default:
            return state
        }
    }
}

class ContainerTitleNavigationHandler {
    func handle(
        setCurrentViewControllerAction: ContainerTitleNavigationAction.SetCurrentViewControllerAction,
        _ state: ContainerTitleNavigationState
    ) -> ContainerTitleNavigationState {
        state.changeValue(
            subAction: .setCurrentViewControllerInNavigationActionSuccess,
            currentViewController: setCurrentViewControllerAction.currentViewControllerInNavigation
        )
    }

    func handle(
        backAction: ContainerTitleNavigationAction.BackAction,
        _ state: ContainerTitleNavigationState
    ) -> ContainerTitleNavigationState {
        state.changeValue(
            subAction: .backActionSuccess
        )
    }

    func handle(
        hideCloseButtonAction: ContainerTitleNavigationAction.HideCloseButtonAction,
        _ state: ContainerTitleNavigationState
    ) -> ContainerTitleNavigationState {
        return state.changeValue(
            subAction: .hideButttonActionSuccess
        )
    }

    func handle(
        printCloseButtonAction: ContainerTitleNavigationAction.PrintCloseButtonAction,
        _ state: ContainerTitleNavigationState
    ) -> ContainerTitleNavigationState {
        state.changeValue(
            subAction: .printButtonActionSuccess
        )
    }

    func handle(
        setTitleAction: ContainerTitleNavigationAction.SetTitleAction,
        _ state: ContainerTitleNavigationState
    ) -> ContainerTitleNavigationState {
        state.changeValue(
            title: setTitleAction.title,
            subAction: .setTitleActionSuccess
        )
    }
}
