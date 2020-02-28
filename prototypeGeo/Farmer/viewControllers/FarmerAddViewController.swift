//
//  FarmerCreateViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FarmerAddViewController: UIViewController {

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(self.navigationController?.viewControllers.contains(self))
    }

}
