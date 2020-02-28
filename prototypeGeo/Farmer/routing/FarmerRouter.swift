//
//  FarmerRouting.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-09.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit
import ReSwift
import RxSwift

public class FarmerRouter {
    static let URL_FARMER_TABLE_VIEW_TO_FARMER_CREATE = "FarmerTableViewController->FarmerCreateViewController"
    private var farmerTableViewController: UIViewController?
    let rootViewController: UINavigationController
    var farmerCreateViewController: UIViewController?
    let makeFarmerCreateViewController: () -> FarmerAddViewController
    let navigationState$: Observable<NavigationState>
    var disposableNavigationState: Disposable?
    init(
        parentController: UINavigationController,
        navigationState$: Observable<NavigationState>,
        makeFarmerAddViewController: @escaping () -> FarmerAddViewController
    ) {
        self.rootViewController = parentController
        self.farmerTableViewController = parentController.viewControllers[0] as? FarmerTableViewController
        self.makeFarmerCreateViewController = makeFarmerAddViewController
        self.navigationState$ = navigationState$
    }
    
    public func initRouter() {
        self.disposableNavigationState = self.navigationState$.subscribe {even in
            even.element.map { navigationStateUnwrap in
                
                if navigationStateUnwrap.url == FarmerRouter.URL_FARMER_TABLE_VIEW_TO_FARMER_CREATE {
                    self.goToFarmerCreateViewController()
                }
            }
        }
    }
    
    private func pushViewController(toNavigationController: UINavigationController, viewController: UIViewController) {
        toNavigationController.pushViewController(viewController, animated: true)
    }
    
    private func goToFarmerCreateViewController() {
        let farmerCreateViewController = self.getFarmerViewController()
        self.pushViewController(toNavigationController: self.rootViewController, viewController: farmerCreateViewController)
    }
    
    private func getFarmerViewController() -> UIViewController {
        if let farmerCreateViewControllerUnwrap = self.farmerCreateViewController {
            return farmerCreateViewControllerUnwrap
        }
    
        return self.makeFarmerCreateViewController()
    }
}
    


