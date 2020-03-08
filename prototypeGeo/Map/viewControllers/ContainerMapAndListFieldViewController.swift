//
//  ContainerMapAndListFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndListFieldViewController: UIViewController {
    let mapFieldViewController: MapFieldViewController
    let containerFieldNavigationViewController: ContainerFieldNavigationViewController
    var containerMapAndListFieldView: ContainerMapAndListFieldView = ContainerMapAndListFieldView()
    var firstCall: Bool = true

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        mapFieldViewController: MapFieldViewController,
        containerFieldNavigationViewController: ContainerFieldNavigationViewController
    ) {
        self.mapFieldViewController = mapFieldViewController
        self.containerFieldNavigationViewController = containerFieldNavigationViewController
        super.init(nibName: nil, bundle: nil)
    }
    override func loadView() {
        view = containerMapAndListFieldView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initContainerView()
        initDragGestureOnContainerFieldNavigation()
       // self.containerMapAndListFieldView.slideContainerFieldNavigationViewToMaxPosition()

    }

    private func initContainerView() {
        self.addChilds(mapFieldViewController, containerFieldNavigationViewController)
        containerMapAndListFieldView.initViewOf(viewOfMapFieldController: mapFieldViewController.view)
        containerMapAndListFieldView.initViewOf(containerFieldNavigationView: containerFieldNavigationViewController.view)
        mapFieldViewController.didMove(toParent: self)
        containerFieldNavigationViewController.didMove(toParent: self)
    }

    private func initDragGestureOnContainerFieldNavigation() {
        containerMapAndListFieldView.initDragGestureFor(titleView: containerFieldNavigationViewController.getTitleView())
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        print("oklm1")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if firstCall {
            self.containerMapAndListFieldView.slideContainerFieldNavigationViewToMaxPosition()
            firstCall = false
        } else {
            self.containerMapAndListFieldView.setminYContainerFieldNavigationViewToCurrentPosition()
        }
    }
}
