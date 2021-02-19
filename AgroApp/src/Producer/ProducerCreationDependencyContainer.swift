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
            selectFormCulturalPracticeInterraction: SelectFormCulturalPracticeInterractionImpl(actionDispatcher: stateStore)
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

    func makeCulturalPracticeFormObservable() -> Observable<CulturalPracticeFormState> {
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
            culturalPracticeStateObs: makeCulturalPracticeFormObservable(),
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
            navigationController: makeNavigationController(),
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
            inputFormCulturalPracticeInterraction: InputFormCulturalPracticeInteractionImpl(actionDispatcher: stateStore)
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
            interaction: ContainerFormCulturalPracticeInteractionImpl(actionDispatcher: stateStore)
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

    // MARK: - Methods AddProducerForm

    func makeAddProducerFormStateObservalbe() -> Observable<AddProducerFormState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<AddProducerFormState> in
            subscription
                .select { $0.addProducerFormState }
                .skip {$0 == $1}
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }

    func makeAddProducerFormInteraction() -> AddProducerFormInteraction {
        AddProducerFormInteractionImpl(actionDispatcher: self.stateStore)
    }

    func makeAddProducerFormViewState() -> AddProducerFormViewModelImpl.ViewState {
        AddProducerFormViewModelImpl.ViewState()
    }

    func makeAddProducerFormViewModel(viewState: AddProducerFormViewModelImpl.ViewState) -> AddProducerFormViewModel {
        AddProducerFormViewModelImpl(
            addProducerFormStateObservable: makeAddProducerFormStateObservalbe(),
            addProducerFormInteraction: makeAddProducerFormInteraction(),
            viewState: viewState
        )
    }

    func makeAddProducerFormView(
        addProducerFormViewModel: AddProducerFormViewModel,
        keyboardFollower: KeyboardFollower,
        viewState: AddProducerFormViewModelImpl.ViewState
    ) -> AddProducerFormView {
        AddProducerFormView(
            addProducerFormViewModel: addProducerFormViewModel,
            keyboardFollower: keyboardFollower,
            viewState: viewState
        )
    }

    func makeAddProducerFormSettingViewController(
        addProducerFormView: AddProducerFormView
    ) -> SettingViewController<AddProducerFormView> {
        SettingViewController(myView: addProducerFormView)
    }

    func makeAddProducerFormHostingController() -> SettingViewController<AddProducerFormView> {
        let viewState = makeAddProducerFormViewState()
        var addProducerFormViewModel = makeAddProducerFormViewModel(viewState: viewState)

        let addProducerFormView = makeAddProducerFormView(
            addProducerFormViewModel: addProducerFormViewModel,
            keyboardFollower: KeyboardFollower(),
            viewState: viewState
        )

        let settingViewController = makeAddProducerFormSettingViewController(
            addProducerFormView: addProducerFormView
        )

        addProducerFormViewModel.viewController = settingViewController
        return settingViewController
    }
    
    // MARK: - Producer List
    
    private func makeProducerListViewController(
        producerListViewModel: ProducerListViewModel
    ) -> ProducerListViewController {
        return ProducerListViewController(producerListViewModel: producerListViewModel)
    }
    
    private func makeProducerListObservableState() -> Observable<ProducerListState> {
        stateStore.makeObservable(
            transform: {(subscription: Subscription<AppState>)
                -> Subscription<ProducerListState> in
            subscription.select { appState in
                appState.producerListState
            }
        }).subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }
    
    private func makeProducerListInteraction(stateStore: Store<AppState>) -> ProducerListInteraction {
        return ProducerListInteractionImpl(actionDispatcher: stateStore)
    }
    
    private func makeProducerListViewModel(
        producerListInteraction: ProducerListInteraction,
        producerListObservable: Observable<ProducerListState>
    ) -> ProducerListViewModel {
        return ProducerListViewModelImpl(
            producerListInteraction: producerListInteraction,
            producerListStateObservable: producerListObservable
        )
    }
    
    func makeProducerNavigation() -> UINavigationController {
        let producerListInterraction = self.makeProducerListInteraction(stateStore: stateStore)
        let producerListObservableState = self.makeProducerListObservableState()
        
        let producerListViewModel = self.makeProducerListViewModel(
            producerListInteraction: producerListInterraction,
            producerListObservable: producerListObservableState
        )
        
        let producerListViewController = self.makeProducerListViewController(producerListViewModel: producerListViewModel)
        let producerNavigation = UINavigationController(rootViewController: producerListViewController)
        
        producerListViewController.tabBarItem = UITabBarItem(
            title: "Producteurs",
            image: UIImage(systemName: "person.2.square.stack"),
            tag: 1
        )
        
        return producerNavigation
    }
    
    // MARK: - Methods navigation

    func makeNavigationController() -> UINavigationController {
        UINavigationController(rootViewController: self.makeAddProducerFormHostingController())
    }

    func makeMapFieldNavigationController() -> UINavigationController {
        let navController = UINavigationController(rootViewController: self.makeMapFieldViewController())
        let tabBarItem = UITabBarItem(title: "Carte", image: UIImage(named: "mapsIcon"), tag: 2)
        navController.tabBarItem = tabBarItem
        return navController
    }

    // MARK: - ContainerMapAndTitleNavigationController

    func processInitMapField() -> UINavigationController {
        makeMapFieldNavigationController()
    }

    func processNavigation() -> UINavigationController {
        makeNavigationController()
    }

    func makeContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController {
        ContainerMapAndTitleNavigationController(
            mapFieldViewController: makeMapFieldViewController(),
            containerTitleNavigationViewController: makeContainerTitleNavigationViewController(),
            containerMapAndTitleNavigationViewModel: makeContainerMapAndTitleNavigationViewModel()
        )
    }
    
    func makeContainerMapAndTitleNavigationInteraction() -> ContainerMapAndTitleNavigationInteraction {
        ContainerMapAndTitleNavigationInteractionImpl(actionDispatcher: stateStore)
    }
    
    func makeContainerMapAndTitleNavigationStateObservable() -> Observable<ContainerMapAndTitleNavigationState> {
        self.stateStore.makeObservable { (subscription: Subscription<AppState>) -> Subscription<ContainerMapAndTitleNavigationState> in
            subscription
                .select { $0.containerMapAndTitleNavigationState }
                .skip {$0 == $1}
        }.subscribeOn(Util.getSchedulerBackgroundForReSwift())
    }
    
    func makeContainerMapAndTitleNavigationViewModel() -> ContainerMapAndTitleNavigationViewModel {
        ContainerMapAndTitleNavigationViewModelImpl(
            stateObservable: makeContainerMapAndTitleNavigationStateObservable(),
            interaction: makeContainerMapAndTitleNavigationInteraction()
        )
    }
}

protocol ProducerCreationDependencyContainer {
    func makeMapFieldNavigationController() -> UINavigationController
    func makeNavigationController() -> UINavigationController
    func makeCulturalPracticeFormViewController() -> CulturalPracticeFormViewController
    func makeFieldListViewController() -> FieldListViewController
    func makeContainerMapAndTitleNavigationController() -> ContainerMapAndTitleNavigationController
    func processInitMapField() -> UINavigationController
    func makeSelectFormCulturalPracticeViewController() -> SelectFormCulturalPracticeViewController
    func makeInputFormCulturalPracticeHostingController() -> SettingViewController<InputFormCulturalPracticeView>

    func makeContainerFormCulturalPracticeHostingController() -> SettingViewController<ContainerFormCulturalPracticeView>

    func makeAddProducerFormHostingController() -> SettingViewController<AddProducerFormView>
    func makeProducerNavigation() -> UINavigationController
}
