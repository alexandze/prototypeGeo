//
//  ContainerMapAndListFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndTitleNavigationController: UIViewController {
    var mapFieldViewController: MapFieldViewController
    var containerTitleNavigationViewController: ContainerTitleNavigationViewController
    let containerMapAndTitleNavigationView: ContainerMapAndTitleNavigationView
    var containerMapAndTitleNavigationViewModel: ContainerMapAndTitleNavigationViewModel
    var firstCall: Bool = true

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        mapFieldViewController: MapFieldViewController,
        containerTitleNavigationViewController: ContainerTitleNavigationViewController,
        containerMapAndTitleNavigationViewModel: ContainerMapAndTitleNavigationViewModel,
        containerMapAndTitleNavigationView: ContainerMapAndTitleNavigationView = ContainerMapAndTitleNavigationView()
    ) {
        self.mapFieldViewController = mapFieldViewController
        self.containerTitleNavigationViewController = containerTitleNavigationViewController
        self.containerMapAndTitleNavigationView = containerMapAndTitleNavigationView
        self.containerMapAndTitleNavigationViewModel = containerMapAndTitleNavigationViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public override func loadView() {
        view = containerMapAndTitleNavigationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        initDragGestureOnContainerFieldNavigation()
        hideNavigationAndTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerMapAndTitleNavigationViewModel.hideValidateButton = { [weak self] in self?.containerMapAndTitleNavigationView.hideValidateButton() }
        containerMapAndTitleNavigationViewModel.showValidateButton = { [weak self] in self?.containerMapAndTitleNavigationView.showValidateButton() }
        containerMapAndTitleNavigationViewModel.closeContainer = { [weak self] in self?.closeContainer() }
        containerMapAndTitleNavigationViewModel.subscribeToObserverState()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        containerMapAndTitleNavigationViewModel.disposes()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if firstCall {
            self.containerMapAndTitleNavigationView.slideContainerFieldNavigationViewToMaxPosition()
            firstCall = false
        } else {
            self.containerMapAndTitleNavigationView.setminYContainerFieldNavigationViewToCurrentPosition()
        }
    }
    
    private func initContainerView() {
        self.addChilds(mapFieldViewController, containerTitleNavigationViewController)
        containerMapAndTitleNavigationView.initViewOfMapFieldController(mapFieldViewController.view)
        initBackButton()
        initValidateButton()
        containerMapAndTitleNavigationView.initViewOfContainerNavigation(containerTitleNavigationViewController.view)
        mapFieldViewController.didMove(toParent: self)
        containerTitleNavigationViewController.didMove(toParent: self)
    }
    
    private func initBackButton() {
        containerMapAndTitleNavigationView.initBackButton()
        containerMapAndTitleNavigationView.handleBackButtonFunc = {[weak self] in self?.containerMapAndTitleNavigationViewModel.handleBackButton() }
    }
    
    private func initValidateButton() {
        containerMapAndTitleNavigationView.initValidateButton()
        containerMapAndTitleNavigationView.handleValideButtonFunc = { [weak self] in self?.containerMapAndTitleNavigationViewModel.handleValidateButton()  }
        containerMapAndTitleNavigationView.hideValidateButton()
    }

    private func initDragGestureOnContainerFieldNavigation() {
        containerMapAndTitleNavigationView.initDragGestureFor(titleView: containerTitleNavigationViewController.getTitleView())
    }
    
    private func hideNavigationAndTabBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    private func removeChildrenView() {
        mapFieldViewController.willMove(toParent: nil)
        mapFieldViewController.view.removeFromSuperview()
        mapFieldViewController.removeFromParent()
        containerTitleNavigationViewController.willMove(toParent: nil)
        containerTitleNavigationViewController.view.removeFromSuperview()
        containerTitleNavigationViewController.removeFromParent()
    }
    
    // TODO mettre dans le view model
    private func closeContainer() {
        removeChildrenView()
        containerTitleNavigationViewController.popAllViewController()
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("********* ContainerMapAndTitleNavigationController ***********")
    }
}
