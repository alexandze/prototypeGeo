//
//  AppDependencyContainer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift
import RxSwift

class AppDependencyContainerImpl: AppDependencyContainer {

    let stateStore: Store<AppState> = {
        return Store(
            reducer: Reducers.appReducer,
            state: AppState(farmerState: FarmerState(), mapFieldState: MapState()),
            middleware: [
                FarmerMiddleware.shared.makeGetFarmersMiddleware(),
                MapFieldMiddleware.shared.makeGetAllFieldMiddleware()
            ],
            automaticallySkipsRepeats: true
        )
    }()

    let mapDependencyContainer: MapDependencyContainer

    init() {
        self.mapDependencyContainer = MapDependencyContainerImpl(stateStore: self.stateStore)
    }

    func makeFarmerTableViewController(
        farmerTableViewModel: FarmerTableViewModel
    ) -> FarmerTableViewController {
        return FarmerTableViewController(farmerViewModel: farmerTableViewModel)
    }

    func makeFarmerTableViewStateObservable() -> Observable<FarmerTableViewControllerState> {
        stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>)
                -> Subscription<FarmerTableViewControllerState> in
            subscription.select { appState in
                appState.farmerState.farmerTableViewControllerState
            }
        })
    }

    func makeFarmerTableViewInteractions(stateStore: Store<AppState>) -> FarmerTableViewInteractions {
        return FarmerTableViewInteractionsImpl(actionDispatcher: stateStore)
    }

    func makeFarmerTableViewModel(
        farmerTableViewInteractions: FarmerTableViewInteractions,
        makeFarmerTableViewStateObservable: Observable<FarmerTableViewControllerState>
    ) -> FarmerTableViewModel {
        return FarmerTableViewModel(
            farmerTableViewInteraction: farmerTableViewInteractions,
            farmerTableViewControllerStateObservable: makeFarmerTableViewStateObservable
        )
    }

    func makeFarmerCreateViewController() -> FarmerAddViewController {
        return FarmerAddViewController()
    }

    func makeFarmerAddViewController() -> FarmerAddViewController {
        FarmerAddViewController()
    }

    func processInitFarmerPackage() -> UINavigationController {
        let farmerTableViewInteraction = self.makeFarmerTableViewInteractions(stateStore: self.stateStore)
        let makeFarmerTableViewStateObservable = self.makeFarmerTableViewStateObservable()
        let farmerTableViewModel = self.makeFarmerTableViewModel(
            farmerTableViewInteractions: farmerTableViewInteraction,
            makeFarmerTableViewStateObservable: makeFarmerTableViewStateObservable
        )
        let farmerTableViewController = self.makeFarmerTableViewController(
            farmerTableViewModel: farmerTableViewModel
        )
        let farmerNavigationController = UINavigationController(rootViewController: farmerTableViewController)
        farmerNavigationController.tabBarItem = UITabBarItem(
            title: "Agriculteur",
            image: UIImage(named: "contact"),
            tag: 1)
        return farmerNavigationController
    }

    func proccessInitTabBarController() -> UITabBarController {
        let farmerNavigationController = self.processInitFarmerPackage()
        let mapFieldNavigationController = self.mapDependencyContainer.processInitMapField()
        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [farmerNavigationController, mapFieldNavigationController]
        tabBarController.selectedIndex = 1

        tabBarController.tabBar.tintColor = Util.getOppositeColorBlackOrWhite()

        return tabBarController
    }
    func processInitContainerMapAndFieldNavigation() -> ContainerMapAndListFieldViewController {
        mapDependencyContainer.processInitContainerMapAndFieldNavigation()
    }
}

protocol AppDependencyContainer {
    func proccessInitTabBarController() -> UITabBarController
    func processInitContainerMapAndFieldNavigation() -> ContainerMapAndListFieldViewController
}
