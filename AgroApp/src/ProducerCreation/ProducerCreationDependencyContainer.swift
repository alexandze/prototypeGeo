//
//  ProducerCreationDependencyContainerImpl.swift
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
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
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
                .select { $0.mapFieldState }
                .skip { $0.uuidState == $1.uuidState }
        }).subscribeOn(Util.getSchedulerBackgroundForReSwift())
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
                appState.fieldListState
            }.skip { $0 == $1 }
        }).subscribeOn(Util.getSchedulerBackgroundForReSwift())
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
        }).subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }

    func makeCulturalPraticeFormInteraction() -> CulturalPraticeFormInteraction {
        CulturalPraticeFormInteractionImpl(actionDispatcher: self.stateStore)
    }

    func makeCulturalPracticeFormViewModel() -> CulturalPraticeFormViewModel {
        CulturalPraticeFormViewModelImpl(
            culturalPracticeStateObs: makeCurrentFieldObservable(),
            culturalPraticeFormInteraction: makeCulturalPraticeFormInteraction()
        )
    }

    func makeCulturalPracticeFormViewController() -> CulturalPracticeFormViewController {
        CulturalPracticeFormViewController(culturalPraticeViewModel: self.makeCulturalPracticeFormViewModel())
    }

    // MARK: - Methods ContainerTitleNavigation

    func makeContainerTitleNavigationObservable() -> Observable<ContainerTitleNavigationState> {
        self.stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>) -> Subscription<ContainerTitleNavigationState> in
            subscription
                .select { appState in
                    appState.containerTitleNavigationState
            }
            .skip { $0 == $1 }
        }).subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }

    func makeContainerTitleNavigationViewModel() -> ContainerTitleNavigationViewModel {
        ContainerTitleNavigationViewModelImpl(
            stateObservable: makeContainerTitleNavigationObservable(),
            actionDispatcher: self.stateStore
        )
    }

    func makeContainerTitleNavigationViewController() -> ContainerTitleNavigationViewController {
        ContainerTitleNavigationViewController(
            navigationFieldController: makeFieldListNavigationController(),
            containerTitleNavigationViewModel: makeContainerTitleNavigationViewModel()
        )
    }

    // MARK: - Methods InputFormCulturalPractice

    func makeInputFormCuluralPracticeObservable() -> Observable<InputFormCulturalPracticeState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<InputFormCulturalPracticeState> in
            subscription
                .select { $0.inputFormCulturalPracticeState }
                .skip { $0.uuidState == $1.uuidState }
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }

    func makeInputFormCulturalPracticeViewModel() -> InputFormCulturalPracticeViewModelImpl {
        InputFormCulturalPracticeViewModelImpl(
            stateObserver: makeInputFormCuluralPracticeObservable(),
            viewState: InputFormCulturalPracticeViewModelImpl.ViewState(),
            actionDispatcher: self.stateStore
        )
    }

    func makeInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView> {
        let viewModel = makeInputFormCulturalPracticeViewModel()

        let inputFormView = InputFormCulturalPracticeView(
            viewModel: viewModel,
            keyboardFollower: KeyboardFollower()
        )

        let settingViewController = SettingViewController(myView: inputFormView)
        viewModel.settingViewController = settingViewController
        return  settingViewController
    }

    // MARK: - Methods ContainerFormCulturalPractice

    func makeContainerFormCulturalPracticeObservable() -> Observable<ContainerFormCulturalPracticeState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<ContainerFormCulturalPracticeState> in
            subscription
                .select { $0.containerFormCulturalPracticeState }
                .skip { $0.uuidState == $1.uuidState }
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }

    func makeContainerFormCulturalPracticeViewModel() -> ContainerFormCulturalPracticeViewModelImpl {
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

        let settingViewController = SettingViewController(myView: containerFormView)
        viewModel.settingViewController = settingViewController
        return settingViewController
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

    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController {
        ContainerMapAndTitleNavigationController(
            mapFieldViewController: makeMapFieldViewController(),
            containerTitleNavigationViewController: makeContainerTitleNavigationViewController()
        )
    }
}

protocol ProducerCreationDependencyContainer {
    func makeMapFieldNavigationController() -> UINavigationController
    func makeFieldListNavigationController() -> UINavigationController
    func makeCulturalPracticeFormViewController() -> CulturalPracticeFormViewController
    func makeFieldListViewController() -> FieldListViewController
    func processInitContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController
    func processInitMapField() -> UINavigationController
    func makeSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController
    func makeInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>
    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>
}
