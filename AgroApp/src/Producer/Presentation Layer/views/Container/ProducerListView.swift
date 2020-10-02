//
//  ProducerListView.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class ProducerListView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray6
        tableView.alpha = 0.95
        tableView.rowHeight = 160
        return tableView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        config()
        initPositionTableView()
    }
    
    private func initPositionTableView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func config() {
        backgroundColor = .systemGray6
        alpha = 0.95
    }
}
