//
//  ProfilDependencyContainer.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import ReSwift
import RxSwift
import UIKit
import SwiftUI

class ProfilDependencyContainerImpl: ProfilDependencyContainer {
    private let stateStore: Store<AppState>
    private let profilMakeNavigation: ProfilMakeNavigation

    init(
        stateStore: Store<AppState>
    ) {
        self.stateStore = stateStore
        self.profilMakeNavigation = ProfilMakeNavigationImpl(stateStore: stateStore)
    }
    
    func makeProfilNavigation() -> UINavigationController {
        profilMakeNavigation.makeProfilNavigation()
    }

}

protocol ProfilDependencyContainer {
    func makeProfilNavigation() -> UINavigationController
}
