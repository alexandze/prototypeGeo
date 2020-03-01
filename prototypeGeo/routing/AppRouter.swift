//
//  AppRouter.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class AppRouterImpl: AppRouter {
    var currentViewController: UIViewController?
    
    var viewControllerDictionnary = [String: UIViewController]()
    
    init(rootViewController: UIViewController) {
        self.addViewController(viewController: rootViewController)
    }
    
    func searchViewControllerTo(navigationAction: NavigationAction) -> UIViewController? {
        self.viewControllerDictionnary[navigationAction.to]
    }
    
    func searchViewControllerFrom(navigationAction: NavigationAction) -> UIViewController? {
        self.viewControllerDictionnary[navigationAction.from]
    }
    
    
    func addViewController(viewController: UIViewController) {
        self.currentViewController = viewController
        switch viewController {
        case let navigationController as UINavigationController:
            addViewControllerFromNavigationController(navigationController: navigationController)
        case let containerViewController as ContainerViewController:
            self.addViewControllerFromContainerViewController(containerViewControllers: containerViewController)
            self.addValueInDictionary(key: type(of: (viewController as! Identifier)).identifier, value: viewController)
        case let tabBarController as UITabBarController:
            self.addViewControllerFromTabBarController(tabBarController: tabBarController)
        case let identier as Identifier:
            self.addValueInDictionary(key: type(of: identier).identifier, value: viewController)
        default:
            break
        }
    }
    
    func addViewControllerFromNavigationController(navigationController: UINavigationController) {
        navigationController.viewControllers.forEach {
            switch $0 {
            case let containerViewController as ContainerViewController:
                self.addViewControllerFromContainerViewController(containerViewControllers: containerViewController)
            case let identifier as Identifier:
               self.addValueInDictionary(key: type(of: identifier).identifier, value: $0)
            default:
                break
            }
        }
    }
    
    func addViewControllerFromTabBarController(tabBarController: UITabBarController) {
        tabBarController.viewControllers?.forEach {
            switch $0 {
            case let navigationViewController as UINavigationController:
                self.addViewControllerFromNavigationController(navigationController: navigationViewController)
            case let containerViewController as ContainerViewController:
                self.addViewControllerFromContainerViewController(containerViewControllers: containerViewController)
            case let identifier as Identifier:
                self.addValueInDictionary(key: type(of: identifier).identifier, value: $0)
            default:
                break
            }
        }
    }
    
    func addViewControllerFromContainerViewController(containerViewControllers: ContainerViewController) {
        containerViewControllers.viewControllers.forEach {
            switch $0 {
            case let navigationController as UINavigationController:
                self.addViewControllerFromNavigationController(navigationController: navigationController)
            case let identifier as Identifier:
                self.addValueInDictionary(key: type(of: identifier).identifier, value: $0)
            default:
                break
            }
        }
    }
    
    func addValueInDictionary(key: String, value: UIViewController) {
        if self.viewControllerDictionnary[key] == nil {
            self.viewControllerDictionnary.updateValue(value, forKey: key)
        }
    }
    
}

protocol AppRouter {
    func addViewController(viewController: UIViewController)
    var currentViewController: UIViewController? {get set}
}
