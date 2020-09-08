//
//  FakeViewController.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-08.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FakeViewController: UIViewController {
    let myTitle: String
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String) {
        self.myTitle = title
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UILabel()
        titleView.text = myTitle
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.textColor = Util.getOppositeColorBlackOrWhite()
        
        let subTitleView = UILabel()
        subTitleView.text = "Bientôt disponible"
        subTitleView.translatesAutoresizingMaskIntoConstraints = false
        subTitleView.textColor = Util.getOppositeColorBlackOrWhite()
        
        view.addSubview(titleView)
        view.addSubview(subTitleView)
        
        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5),
            subTitleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
        view.backgroundColor = Util.getBackgroundColor()
        view.alpha = Util.getAlphaValue()
        // Do any additional setup after loading the view.
    }
    
    
}
