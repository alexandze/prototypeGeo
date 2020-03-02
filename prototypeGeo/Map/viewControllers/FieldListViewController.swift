//
//  FieldListViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldListViewController: UIViewController {

    
    
    let fieldListViewModel: FieldListViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        fieldListViewModel: FieldListViewModel
    ) {
        self.fieldListViewModel = fieldListViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = FieldListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
    
    

}
