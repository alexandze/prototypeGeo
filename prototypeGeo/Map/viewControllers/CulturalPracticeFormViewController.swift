//
//  CulturalPracticeFormViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class CulturalPracticeFormViewController: UIViewController {
    let culturalPracticeFormViewModel: CulturalPracticeFormViewModel
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(culturalPracticeFormViewModel: CulturalPracticeFormViewModel) {
        self.culturalPracticeFormViewModel = culturalPracticeFormViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
