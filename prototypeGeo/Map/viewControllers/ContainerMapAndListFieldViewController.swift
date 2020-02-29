//
//  ContainerMapAndListFieldViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerMapAndListFieldViewController: UIViewController {
    
    var mapFieldViewController: MapFieldViewController!
    var fieldListViewController: FieldListViewController!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(
        mapFieldViewModel: MapFieldViewModel,
        
    ) {
        
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
