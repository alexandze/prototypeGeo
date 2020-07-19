//
//  ContainerFieldNavigationViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import RxSwift

class ContainerTitleNavigationViewController: UIViewController {

    let containerTitleNavigationView = ContainerTitleNavigationView()
    let navigationFieldController: UINavigationController
    let containerTitleNavigationViewModel: ContainerTitleNavigationViewModel
    var disposeSubjectViewState: Disposable?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        navigationFieldController: UINavigationController,
        containerTitleNavigationViewModel: ContainerTitleNavigationViewModel
    ) {
        self.navigationFieldController = navigationFieldController
        self.containerTitleNavigationViewModel = containerTitleNavigationViewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = self.containerTitleNavigationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationControllerView()
        initHandlerCloseButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerTitleNavigationViewModel.subscribeToStateObserver()
        disposeSubjectViewState = containerTitleNavigationViewModel.subjectViewState.subscribe(handleViewState(event:))
    }

    func handleViewState(event: Event<ContainerTitleNavigationViewModelImpl.ViewState>) {
        guard let viewState = event.element else { return }

        switch viewState {
        case .setCurrentViewControllerInNavigation(
            currentViewControllerInNavigation: let currentViewControllerInNavigation
            ):
            handleSetCurrentViewControllerInNavigation(currentViewControllerInNavigation: currentViewControllerInNavigation)
        case .hideCloseButton:
            self.handleHideCloseButton()
        case .printCloseButton:
            self.handlePrintButton()
        case .setTitle(title: let title):
            self.handleSetTitle(title)
        case .back:
            self.handleBack()
        }
    }

    private func handleSetCurrentViewControllerInNavigation(
        currentViewControllerInNavigation: ContainerTitleNavigationState.CurrentViewControllerInNavigation
    ) {
        let countViewControllers = navigationFieldController.viewControllers.count

        if countViewControllers == 1 {
            return containerTitleNavigationViewModel.dispatchHideCloseButtonAction()
        }

        containerTitleNavigationViewModel.dispatchPrintCloseButtonAction()
    }

    private func handleHideCloseButton() {
        containerTitleNavigationView.hideCloseButton()
    }

    private func handlePrintButton() {
        containerTitleNavigationView.printCloseButton()
    }

    private func handleSetTitle(_ title: String) {
        containerTitleNavigationView.setTitle(title)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.viewWillAppear(animated)
        containerTitleNavigationViewModel.disposeObservers()
        disposeSubjectViewState?.dispose()
    }

    /// Init view who content navigation controller
    func initNavigationControllerView() {
        self.addChild(self.navigationFieldController)
        hideBarNavigation()

        containerTitleNavigationView.initNavigationControllerView(navigationControllerView: navigationFieldController.view)

        self.navigationFieldController.didMove(toParent: self)
    }

    func initHandlerCloseButton() {
        containerTitleNavigationView.initHandlerCloseButton {
            self.containerTitleNavigationViewModel.handleCloseButton()
        }
    }

    /// Get view who content title
    func getTitleView() -> TitleView {
        containerTitleNavigationView.titleView!
    }

    func hideBarNavigation() {
        navigationFieldController.isNavigationBarHidden = true
    }

    func handleBack() {
        let countViewControllers = navigationFieldController.viewControllers.count

        if countViewControllers > 1 {
            navigationFieldController.popViewController(animated: true)
            return
        }
    }
}
