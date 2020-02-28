//
//  FarmerNavigationController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2019-12-29.
//  Copyright © 2019 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FarmerNavigationController: UINavigationController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(farmerTableViewController: FarmerTableViewController) {
        super.init(rootViewController: farmerTableViewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
