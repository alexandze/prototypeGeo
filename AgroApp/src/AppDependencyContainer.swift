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
                producerListState: ProducerListState(uuidState: UUID().uuidString),
                mapFieldState: MapFieldState(uuidState: UUID().uuidString),
                fieldListState: FieldListState(uuidState: UUID().uuidString),
                culturalPracticeState: CulturalPracticeFormState(uuidState: UUID().uuidString),
                selectFormCulturalPracticeState: SelectFormCulturalPracticeState(uuidState: UUID().uuidString),
                inputFormCulturalPracticeState: InputFormCulturalPracticeState(uuidState: UUID().uuidString),
                containerFormCulturalPracticeState: ContainerFormCulturalPracticeState(uuidState: UUID().uuidString),
                containerTitleNavigationState: ContainerTitleNavigationState(uuidState: UUID().uuidString),
                addProducerFormState: AddProducerFormState(uuidState: UUID().uuidString),
                loginState: LoginState(uuidState: UUID().uuidString)
            ),
            middleware: [
                FarmerMiddleware.shared.makeGetFarmersMiddleware()
            ],
            automaticallySkipsRepeats: true
        )
    }()

    let producerCreationDependencyContainer: ProducerCreationDependencyContainer
    
    let authenticationDependencyContainer: AuthenticationDependencyContainer

    init() {
        self.producerCreationDependencyContainer = ProducerCreationDependencyContainerImpl(stateStore: self.stateStore)
        
        self.authenticationDependencyContainer = AuthenticationDependencyContainerImpl(stateStore: self.stateStore)
    }
    
    func proccessInitTabBarController() -> UITabBarController {
        let producerNavigation = producerCreationDependencyContainer.makeProducerNavigation()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [producerNavigation]
        tabBarController.tabBar.tintColor = Util.getOppositeColorBlackOrWhite()
        return tabBarController
    }

    // MARK: - MapField Navigation

    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController {
        producerCreationDependencyContainer.processInitContainerMapAndTitleNavigationController()
    }

    func processInitCulturalPracticeViewController() -> CulturalPracticeFormViewController {
        producerCreationDependencyContainer.makeCulturalPracticeFormViewController()
    }

    func processInitSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController {
        producerCreationDependencyContainer.makeSelectFormCulturalPracticeViewController()
    }

    func processInitInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView> {
        producerCreationDependencyContainer.makeInputFormCulturalPracticeHostingController()
    }

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView> {
        producerCreationDependencyContainer.makeContainerFormCulturalPracticeHostingController()
    }

    func makeAddProducerFormHostingController() -> SettingViewController<AddProducerFormView> {
        self.producerCreationDependencyContainer.makeAddProducerFormHostingController()
    }

    func makeFieldListViewController() -> FieldListViewController {
        self.producerCreationDependencyContainer.makeFieldListViewController()
    }
}

protocol AppDependencyContainer {
    var producerCreationDependencyContainer: ProducerCreationDependencyContainer { get }
    var authenticationDependencyContainer: AuthenticationDependencyContainer { get }
    func proccessInitTabBarController() -> UITabBarController

    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController

    func processInitCulturalPracticeViewController() -> CulturalPracticeFormViewController

    func processInitSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController

    func processInitInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>

    func makeAddProducerFormHostingController() ->
        SettingViewController<AddProducerFormView>

    func makeFieldListViewController() -> FieldListViewController
}
