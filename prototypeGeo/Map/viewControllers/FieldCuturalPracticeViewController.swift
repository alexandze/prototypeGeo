//
//  FieldCuturalPracticeViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-01.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldCuturalPracticeViewController: UIViewController, Identifier {
    static var identifier: String = "FieldCuturalPracticeViewController"

    let fieldCulturalPracticeViewModel: FieldCulturalPraticeViewModel

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(fieldCulturalPracticeViewModel: FieldCulturalPraticeViewModel) {
        self.fieldCulturalPracticeViewModel = fieldCulturalPracticeViewModel
        super.init(nibName: nil, bundle: nil)
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
