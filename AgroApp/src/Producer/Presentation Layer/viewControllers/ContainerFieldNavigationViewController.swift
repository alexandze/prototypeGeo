//
//  ContainerFieldNavigationViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerTitleNavigationViewController: UIViewController {

    let containerTitleNavigationView = ContainerTitleNavigationView()
    let navigationFieldController: UINavigationController

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(
        navigationFieldController: UINavigationController
    ) {
        self.navigationFieldController = navigationFieldController
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        self.view = self.containerTitleNavigationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationControllerView()
    }

    /// Init view who content navigation controller
    func initNavigationControllerView() {
        self.addChild(self.navigationFieldController)
        navigationFieldController.isNavigationBarHidden = true
        containerTitleNavigationView.initNavigationControllerView(navigationControllerView: navigationFieldController.view)
        self.navigationFieldController.didMove(toParent: self)
    }

    /// Get view who content title
    func getTitleView() -> TitleView {
        containerTitleNavigationView.titleView!
    }
}
