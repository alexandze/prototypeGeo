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
                loginState: LoginState(uuidState: UUID().uuidString),
                containerMapAndTitleNavigationState: ContainerMapAndTitleNavigationState(uuidState: UUID().uuidString),
                profilState: ProfilState(uuidState: UUID().uuidString)
            ),
            middleware: [ContainerMapAndTitleNavigationMiddleware().middleware, ProducerListMiddleware().middleware],
            automaticallySkipsRepeats: true
        )
    }()

    let producerCreationDependencyContainer: ProducerCreationDependencyContainer
    let authenticationDependencyContainer: AuthenticationDependencyContainer
    let profilDependencyContainer: ProfilDependencyContainer

    init() {
        self.producerCreationDependencyContainer = ProducerCreationDependencyContainerImpl(stateStore: self.stateStore)
        self.authenticationDependencyContainer = AuthenticationDependencyContainerImpl(stateStore: self.stateStore)
        self.profilDependencyContainer = ProfilDependencyContainerImpl(stateStore: self.stateStore)
    }
    
    func proccessInitTabBarController() -> UITabBarController {
        let producerNavigation = producerCreationDependencyContainer.makeProducerNavigation()
        let tabBarController = UITabBarController()
        
        let profilNavigationController = profilDependencyContainer.makeProfilNavigation()
        
        profilNavigationController.tabBarItem = UITabBarItem(
            title: "Profil",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        
        let makeScenarionFakeController = FakeViewController(title: "Créer Scénario")
        makeScenarionFakeController.title = "Scénario"
        
        makeScenarionFakeController.tabBarItem = UITabBarItem(
            title: "Scénario",
            image: UIImage(systemName: "slider.horizontal.3"),
            tag: 2
        )
        
        let executeScenarionFakeController = FakeViewController(title: "Exécuter Scénario")
        executeScenarionFakeController.title = "Exécuter"
        
        executeScenarionFakeController.tabBarItem = UITabBarItem(
            title: "Exécuter",
            image: UIImage(systemName: "play"),
            tag: 3
        )
        
        tabBarController.viewControllers = [
            producerNavigation,
            UINavigationController(rootViewController: makeScenarionFakeController),
            UINavigationController(rootViewController: executeScenarionFakeController),
            profilNavigationController
        ]
    
        tabBarController.tabBar.tintColor = Util.getOppositeColorBlackOrWhite()
        return tabBarController
    }

    // MARK: - MapField Navigation

    func makeContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController {
        producerCreationDependencyContainer.makeContainerMapAndTitleNavigationController()
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

    func makeContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController

    func processInitCulturalPracticeViewController() -> CulturalPracticeFormViewController

    func processInitSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController

    func processInitInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>

    func makeAddProducerFormHostingController() ->
        SettingViewController<AddProducerFormView>

    func makeFieldListViewController() -> FieldListViewController
}
