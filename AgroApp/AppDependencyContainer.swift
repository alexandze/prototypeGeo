//
//  AppDependencyContainer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit

class AppDependencyContainerImpl: AppDependencyContainer {

    let stateStore: Store<AppState> = {
        return Store(
            reducer: Reducers.appReducer,
            state: AppState(
                farmerState: FarmerState(),
                mapFieldState: MapFieldState(uuidState: UUID().uuidString),
                fieldListState: FieldListState(uuidState: UUID().uuidString),
                culturalPracticeState: CulturalPracticeFormState(uuidState: UUID().uuidString),
                selectFormCulturalPracticeState: SelectFormCulturalPracticeState(uuidState: UUID().uuidString),
                inputFormCulturalPracticeState: InputFormCulturalPracticeState(uuidState: UUID().uuidString),
                containerFormCulturalPracticeState: ContainerFormCulturalPracticeState(uuidState: UUID().uuidString),
                containerTitleNavigationState: ContainerTitleNavigationState(uuidState: UUID().uuidString)
            ),
            middleware: [
                FarmerMiddleware.shared.makeGetFarmersMiddleware(),
                MapFieldMiddleware.shared.makeGetAllFieldMiddleware()
            ],
            automaticallySkipsRepeats: true
        )
    }()

    let producerCreationDependencyContainer: ProducerCreationDependencyContainer

    init() {
        self.producerCreationDependencyContainer = ProducerCreationDependencyContainerImpl(stateStore: self.stateStore)
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
        let mapFieldNavigationController = self.producerCreationDependencyContainer.processInitMapField()
        let tabBarController = UITabBarController()

        tabBarController.viewControllers = [farmerNavigationController, mapFieldNavigationController]
        tabBarController.selectedIndex = 1

        tabBarController.tabBar.tintColor = Util.getOppositeColorBlackOrWhite()

        return tabBarController
    }
    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController {
        producerCreationDependencyContainer.processInitContainerMapAndTitleNavigationController()
    }

    func processInitCulturalPracticeViewController() -> CulturalPraticeViewController {
        producerCreationDependencyContainer.makeCulturalPracticeViewController()
    }

    func processInitCulturalPracticeFormViewController() -> SelectFormCulturalPracticeViewController {
        producerCreationDependencyContainer.makeSelectFormCulturalPracticeViewController()
    }

    func processInitInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView> {
        producerCreationDependencyContainer.makeInputFormCulturalPracticeHostingController()
    }

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView> {
        producerCreationDependencyContainer.makeContainerFormCulturalPracticeHostingController()
    }
}

protocol AppDependencyContainer {
    var producerCreationDependencyContainer: ProducerCreationDependencyContainer {get}
    func proccessInitTabBarController() -> UITabBarController
    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController
    func processInitCulturalPracticeViewController() -> CulturalPraticeViewController
    func processInitCulturalPracticeFormViewController() -> SelectFormCulturalPracticeViewController
    func processInitInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>
}
