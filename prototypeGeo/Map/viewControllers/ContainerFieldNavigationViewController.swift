//
//  ContainerFieldNavigationViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerFieldNavigationViewController: UIViewController {

    let containerFieldNavigationView = ContainerFieldNavigationView()
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
        self.view = self.containerFieldNavigationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationView()
    }
    
    
    func initNavigationView() {
        self.addChild(self.navigationFieldController)
        navigationFieldController.isNavigationBarHidden = true
        containerFieldNavigationView.initNavigationView(navigationView: navigationFieldController.view)
        self.navigationController?.didMove(toParent: self)
    }
    
    func getTitleView() -> TitleView {
        containerFieldNavigationView.titleView!
    }
}
