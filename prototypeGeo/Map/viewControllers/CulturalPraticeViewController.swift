//
//  CulturalPraticeViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class CulturalPraticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var culturalPraticeViewModel: CulturalPraticeViewModel
    let culturalPraticeView: CulturalPraticeView
    let tableView: UITableView
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(
        culturalPraticeViewModel: CulturalPraticeViewModel
    ) {
        self.culturalPraticeViewModel = culturalPraticeViewModel
        self.culturalPraticeView = CulturalPraticeView()
        self.culturalPraticeViewModel.tableView = self.culturalPraticeView.tableView
        self.tableView = self.culturalPraticeView.tableView
        super.init(nibName: nil, bundle: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
