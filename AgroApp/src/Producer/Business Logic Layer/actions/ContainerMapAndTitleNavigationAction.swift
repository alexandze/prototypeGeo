//
//  ContainerMapAndTitleNavigationAction.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-13.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import ReSwift

struct ContainerMapAndTitleNavigationAction {
    struct HideValidateButtonAction: Action { }
    struct ShowValidateButtonAction: Action { }
    struct CloseContainerAction: Action { }
    struct MakeProducerAction: Action { }
    
    struct MakeProducerSuccessAction: Action {
        var producer: Producer
    }
    
    struct MakeProducerFailureAction: Action { }
    struct KillStateAction: Action { }
}
