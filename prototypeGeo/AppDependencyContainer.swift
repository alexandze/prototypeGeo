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

class AppDependencyContainer {
    
    let stateStore: Store<AppState> = {
        return Store(reducer: Reducers.appReducer, state: AppState(farmerState: FarmerState(), navigationState: NavigationState(), mapFieldState: MapState()), middleware: [FarmerMiddleware.shared.makeGetFarmersMiddleware(), MapFieldMiddleware.shared.makeGetAllFieldMiddleware()], automaticallySkipsRepeats: true)
    }()
    
    let appRouter = AppRouter()
    
    func makeFarmerTableViewController(farmerTableViewModel: FarmerTableViewModel) -> FarmerTableViewController {
        return FarmerTableViewController(farmerViewModel: farmerTableViewModel)
    }
    
    func makeFarmerNavigationController(
        farmerTableViewController: FarmerTableViewController
    ) -> FarmerNavigationController {
        return FarmerNavigationController(farmerTableViewController: farmerTableViewController)
    }
    
    func makeFarmerTableViewState$() -> Observable<FarmerTableViewControllerState> {
        stateStore.makeObservable(transform: {(subscription: Subscription<AppState>) -> Subscription<FarmerTableViewControllerState> in
            subscription.select { appState in
                appState.farmerState.farmerTableViewControllerState
            }
        })
    }
    
    func makeFarmerTableViewInteractions(stateStore: Store<AppState>) -> FarmerTableViewInteractions {
        return FarmerTableViewInteractionsImpl(actionDispatcher: stateStore)
    }
    
    func makeFarmerTableViewModel(farmerTableViewInteractions: FarmerTableViewInteractions, farmerTableViewState$: Observable<FarmerTableViewControllerState>) -> FarmerTableViewModel {
        return FarmerTableViewModel(farmerTableViewInteraction: farmerTableViewInteractions, farmerTableViewControllerState$: farmerTableViewState$)
    }
    
    func makeFarmerRouter(
        farmerNavigationController: FarmerNavigationController,
        navigationState$: Observable<NavigationState>,
        makeFarmerAddViewController: @escaping () -> FarmerAddViewController
    ) -> FarmerRouter {
        return FarmerRouter(parentController: farmerNavigationController, navigationState$: navigationState$, makeFarmerAddViewController: makeFarmerAddViewController)
    }
    
    func makeFarmerCreateViewController() -> FarmerAddViewController {
        return FarmerAddViewController()
    }
    
    func makeNavigationState$(stateStore: Store<AppState>) -> Observable<NavigationState> {
        stateStore.makeObservable(transform: {(subscription: Subscription<AppState>) -> Subscription<NavigationState> in
            subscription.select { appState in
                appState.navigationState
            }.skip {oldNavigationState, newNavigationState in
                oldNavigationState.url == newNavigationState.url
            }
        })
    }
    
    func makeFarmerAddViewController() -> FarmerAddViewController {
        FarmerAddViewController()
    }
    
    
    
    func processInitFarmerPackage() -> FarmerNavigationController {
        let farmerTableViewInteraction = self.makeFarmerTableViewInteractions(stateStore: self.stateStore)
        let farmerTableViewState$ = self.makeFarmerTableViewState$()
        let farmerTableViewModel = self.makeFarmerTableViewModel(farmerTableViewInteractions: farmerTableViewInteraction, farmerTableViewState$: farmerTableViewState$)
        let farmerTableViewController = self.makeFarmerTableViewController(farmerTableViewModel: farmerTableViewModel)
        let farmerNavigationController = self.makeFarmerNavigationController(farmerTableViewController: farmerTableViewController)
        let navigationState$ = self.makeNavigationState$(stateStore: self.stateStore)
        let makeFarmerAdd = {() -> FarmerAddViewController in self.makeFarmerAddViewController()}
        let farmerRouter = self.makeFarmerRouter(farmerNavigationController: farmerNavigationController, navigationState$: navigationState$, makeFarmerAddViewController: makeFarmerAdd)
        farmerRouter.initRouter()
        
        farmerNavigationController.tabBarItem = UITabBarItem(title: "Agriculteur", image: UIImage(named: "contact"), tag: 1)
        
        self.appRouter.farmerRouter = farmerRouter
        return farmerNavigationController
    }
    
    
    
    func makeMapFieldAllStateObservable() -> Observable<MapFieldState> {
        self.stateStore.makeObservable(transform: {(subscription: Subscription<AppState>) -> Subscription<MapFieldState> in
            subscription
                .select { $0.mapFieldState.mapFieldAllFieldsState }
                .skip { $0.uuidState == $1.uuidState }
        })
    }
    
    func createMapFieldInteraction() -> MapFieldInteraction {
        MapFieldInteractionImpl(actionDispatcher: self.stateStore)
    }
    
    func makeMapFieldViewModel() -> MapFieldViewModel {
        let observable = makeMapFieldAllStateObservable()
        let interaction = createMapFieldInteraction()
        return MapFieldViewModel(mapFieldAllFieldState$: observable, mapFieldInteraction: interaction)
    }
    
    func makeMapFieldNavigationController(rootViewController: MapFieldViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        let tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "mapsIcon"), tag: 2)
        navController.tabBarItem = tabBarItem
        return navController
    }
    
    
    func makeMapFieldViewController() -> MapFieldViewController {
        let viewModel = makeMapFieldViewModel()
        let viewController = MapFieldViewController(mapFieldViewModel: viewModel)
        return viewController
    }
    
    func processInitMapField() -> UINavigationController {
        let viewController = makeMapFieldViewController()
        return makeMapFieldNavigationController(rootViewController: viewController)
    }
    
    func proccessInitTabBarController() -> UITabBarController {
        let farmerNavigationController = self.processInitFarmerPackage()
        let mapFieldNavigationController = self.processInitMapField()
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [farmerNavigationController, mapFieldNavigationController]
        tabBarController.selectedIndex = 1
        
        tabBarController.tabBar.tintColor = Util.getOppositeColorBlackOrWhite()
        
        return tabBarController
    }
    
}
