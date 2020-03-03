//
//  ContainerMobileFieldListView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ContainerFieldNavigationView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        configView()
        initViewTitle(parentView: self)
    }
    
    var titleView: TitleView?
     
    private func initViewTitle(parentView: UIView) {
        titleView = TitleView()
        titleView!.clipsToBounds = true
        titleView!.tag = 1
        titleView!.setTitle(title: "Liste des parcelles choisies")
        titleView!.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(titleView!)
        
        NSLayoutConstraint.activate([
            titleView!.topAnchor.constraint(equalTo: parentView.topAnchor),
            titleView!.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            titleView!.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            titleView!.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func initNavigationView(navigationView: UIView) {
        let titleView = viewWithTag(1)!
        navigationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(navigationView)
        
        NSLayoutConstraint.activate([
            navigationView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            navigationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            navigationView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configView() {
        clipsToBounds = true
        layer.cornerRadius = 15
        layer.masksToBounds = true
    }
    
    

}
