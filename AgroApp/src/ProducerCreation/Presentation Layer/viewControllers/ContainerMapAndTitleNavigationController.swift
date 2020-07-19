//
//  ContainerMapAndListFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class ContainerMapAndTitleNavigationController: UIViewController {
    let mapFieldViewController: MapFieldViewController
    let containerTitleNavigationViewController: ContainerTitleNavigationViewController
    var containerMapAndTitleNavigationView: ContainerMapAndTitleNavigationView = ContainerMapAndTitleNavigationView()
    var firstCall: Bool = true

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        mapFieldViewController: MapFieldViewController,
        containerTitleNavigationViewController: ContainerTitleNavigationViewController
    ) {
        self.mapFieldViewController = mapFieldViewController
        self.containerTitleNavigationViewController = containerTitleNavigationViewController
        super.init(nibName: nil, bundle: nil)
    }
    public override func loadView() {
        view = containerMapAndTitleNavigationView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        initDragGestureOnContainerFieldNavigation()
       // self.containerMapAndListFieldView.slideContainerFieldNavigationViewToMaxPosition()

    }

    private func initContainerView() {
        self.addChilds(mapFieldViewController, containerTitleNavigationViewController)
        containerMapAndTitleNavigationView.initViewOf(viewOfMapFieldController: mapFieldViewController.view)
        containerMapAndTitleNavigationView.initViewOf(containerTitleNavigationView: containerTitleNavigationViewController.view)
        mapFieldViewController.didMove(toParent: self)
        containerTitleNavigationViewController.didMove(toParent: self)
    }

    private func initDragGestureOnContainerFieldNavigation() {
        containerMapAndTitleNavigationView.initDragGestureFor(titleView: containerTitleNavigationViewController.getTitleView())
    }

    public override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if firstCall {
            self.containerMapAndTitleNavigationView.slideContainerFieldNavigationViewToMaxPosition()
            firstCall = false
        } else {
            self.containerMapAndTitleNavigationView.setminYContainerFieldNavigationViewToCurrentPosition()
        }
    }
}
