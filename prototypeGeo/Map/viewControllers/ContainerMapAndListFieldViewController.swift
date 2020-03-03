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
    }
    
    private func initContainerView() {
        self.addChilds(mapFieldViewController, containerFieldNavigationViewController)
        containerMapAndListFieldView.initViewOfMapFieldViewController(viewOfMapFieldViewController: mapFieldViewController.view)
        containerMapAndListFieldView.initViewOfContainerFieldNavigationViewController(containerFieldNavigationView: containerFieldNavigationViewController.view)
        mapFieldViewController.didMove(toParent: self)
        containerFieldNavigationViewController.didMove(toParent: self)
        
    }
    
    private func initDragGestureOnContainerFieldNavigation() {
        containerMapAndListFieldView.initDragGestureOnContainerFieldNavigation(titleView: containerFieldNavigationViewController.getTitleView())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.containerMapAndListFieldView.slideContainerFieldNavigationViewToMaxPosition()
    }
}
