//
//  MapDependecyContainer.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-29.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit
import SwiftUI

class ProducerCreationDependencyContainerImpl: ProducerCreationDependencyContainer {
    // MARK: - Properties
    let stateStore: Store<AppState>

    init(stateStore: Store<AppState>) {
        self.stateStore = stateStore
    }
    // MARK: - Methods CulturalPracticeForm

    func makeSelectFormCulturalPracticeStateObservable() -> Observable<SelectFormCulturalPracticeState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<SelectFormCulturalPracticeState> in
            subscription
                .select { $0.selectFormCulturalPracticeState }
                .skip { $0.uuidState == $1.uuidState }
        }
    }

    func makeSelectFormCulturalPracticeViewModel() -> SelectFormCulturalPracticeViewModel {
        SelectFormCulturalPracticeViewModelImpl(
            culturalPracticeFormObs: makeSelectFormCulturalPracticeStateObservable(),
            actionDispatcher: stateStore
        )
    }

    func makeSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController {
        SelectFormCulturalPracticeViewController(culturalPracticeFormViewModel: makeSelectFormCulturalPracticeViewModel())
    }

    // MARK: - Methodes Map

    func makeMapFieldAllStateObservable() -> Observable<MapFieldState> {
        self.stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>) -> Subscription<MapFieldState> in
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
        return MapFieldViewModel(mapFieldAllFieldStateObs: observable, mapFieldInteraction: interaction)
    }

    func makeMapFieldViewController() -> MapFieldViewController {
        let viewModel = makeMapFieldViewModel()
        let viewController = MapFieldViewController(mapFieldViewModel: viewModel)
        return viewController
    }

    // MARK: - Methods FieldList

    func makeFieldListStateObservable() -> Observable<FieldListState> {
        self.stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>) -> Subscription<FieldListState> in
            subscription
                .select { appState in
                appState.mapFieldState.fieldListState
            }.skip { $0 == $1 }
        })
    }

    func makeFieldListInteraction() -> FieldListInteraction {
        FieldListInteractionImpl(actionDispatcher: self.stateStore)
    }

    func makeFieldListViewModel() -> FieldListViewModel {
        return FieldListViewModelImpl(
            fieldListStateObs: self.makeFieldListStateObservable(),
            actionDispatcher: self.stateStore
        )
    }

    func makeFieldListViewController() -> FieldListViewController {
        FieldListViewController(fieldListViewModel: makeFieldListViewModel())
    }

    // MARK: - Methods FieldCultural

    func makeCurrentFieldObservable() -> Observable<CulturalPracticeFormState> {
        self.stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>) -> Subscription<CulturalPracticeFormState> in
            subscription
                .select { appState in
                    appState.culturalPracticeState
            }
            .skip { $0 == $1 }
        })
    }

    func makeCulturalPracticeInteraction() -> FieldCulturalPracticeInteraction {
        FieldCulturalPracticeInteractionImpl(actionDispatcher: self.stateStore)
    }

    func makeCulturalPracticeViewModel() -> CulturalPraticeFormViewModel {
        CulturalPraticeFormViewModelImpl(
            culturalPracticeStateObs: self.makeCurrentFieldObservable(),
            actionDispatcher: self.stateStore
        )
    }

    func makeCulturalPracticeViewController() -> CulturalPraticeViewController {
        CulturalPraticeViewController(culturalPraticeViewModel: self.makeCulturalPracticeViewModel())
    }

    func makeContainerFieldNavigationViewController() -> ContainerFieldNavigationViewController {
        ContainerFieldNavigationViewController(navigationFieldController: makeFieldListNavigationController())
    }

    // MARK: - Methods InputFormCulturalPractice

    func makeInputFormCuluralPracticeObservable() -> Observable<InputFormCulturalPracticeState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<InputFormCulturalPracticeState> in
            subscription
                .select { $0.inputFormCulturalPracticeState }
                .skip { $0.uuidState == $1.uuidState }
        }
    }

    func makeInputFormCulturalPracticeViewModel() -> InputFormCulturalPracticeViewModel {
        InputFormCulturalPracticeViewModelImpl(
            stateObserver: makeInputFormCuluralPracticeObservable(),
            viewState: InputFormCulturalPracticeViewModelImpl.ViewState(),
            actionDispatcher: self.stateStore
        )
    }

    func makeInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView> {
        var viewModel = makeInputFormCulturalPracticeViewModel()
        let inputFormView = InputFormCulturalPracticeView(viewModel: viewModel, keyboardFollower: KeyboardFollower())
        viewModel.view = inputFormView
        return SettingViewController(myView: inputFormView)
    }
    // MARK: - Methods ContainerFormCulturalPractice
    func makeContainerFormCulturalPracticeObservable() -> Observable<ContainerFormCulturalPracticeState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<ContainerFormCulturalPracticeState> in
            subscription
                .select { $0.containerFormCulturalPracticeState }
                .skip { $0.uuidState == $1.uuidState }
        }
    }

    func makeContainerFormCulturalPracticeViewModel() -> ContainerFormCulturalPracticeViewModel {
        ContainerFormCulturalPracticeViewModelImpl(
            stateObserver: makeContainerFormCulturalPracticeObservable(),
            viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState(),
            actionDispatcher: self.stateStore
        )
    }

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView> {
        let viewModel = makeContainerFormCulturalPracticeViewModel()

        let containerFormView = ContainerFormCulturalPracticeView(
            viewModel: viewModel,
            keyboardFollower: KeyboardFollower()
        )

        return SettingViewController(myView: containerFormView)
    }

    // MARK: - Methods navigation
    func makeFieldListNavigationController() -> UINavigationController {
        UINavigationController(rootViewController: self.makeFieldListViewController())
    }

    func makeMapFieldNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self.makeMapFieldViewController())
        let tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "mapsIcon"), tag: 2)
        navController.tabBarItem = tabBarItem
        return navController
    }

    // MARK: - Methods process
    func processInitMapField() -> UINavigationController {
        makeMapFieldNavigationController()
    }

    func processInitFieldListNavigation() -> UINavigationController {
        makeFieldListNavigationController()
    }

    func processInitContainerMapAndFieldNavigation() -> ContainerMapAndListFieldViewController {
        ContainerMapAndListFieldViewController(
            mapFieldViewController: makeMapFieldViewController(),
            containerFieldNavigationViewController: makeContainerFieldNavigationViewController()
        )
    }

}

protocol ProducerCreationDependencyContainer {
    func makeMapFieldNavigationController() -> UINavigationController
    func makeFieldListNavigationController() -> UINavigationController
    func makeCulturalPracticeViewController() -> CulturalPraticeViewController
    func makeFieldListViewController() -> FieldListViewController
    func processInitContainerMapAndFieldNavigation() -> ContainerMapAndListFieldViewController
    func processInitMapField() -> UINavigationController
    func makeSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController
    func makeInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>
    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>
}
