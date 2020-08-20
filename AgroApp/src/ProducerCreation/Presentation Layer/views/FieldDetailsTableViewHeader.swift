//
//  FieldDetailsTableViewHeader.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-19.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class FieldDetailsTableViewHeader: UIView {
    
    var titleFieldButton: String? {
        get {
            fieldButton.title(for: .normal)
        }
        set(title) {
            fieldButton.setTitle(title, for: .normal)
        }
    }
    
    var titleCulturalPracticeButton: String? {
        get {
            culturalPracticeButton.title(for: .normal)
        }
        
        set(title) {
            culturalPracticeButton.setTitle(title, for: .normal)
        }
    }
    
    private var handleFieldButton: (() -> Void)?
    private var handleCulturalPracticeButton: (() -> Void)?
    
    private let fieldButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.cornerRadius = 10
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .gray
        
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        return button
    }()
    
    private let culturalPracticeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.layer.cornerRadius = 10
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .gray
        
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 5
        return button
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.positionFieldAndCulturalPracticeButton()
    }
    
    private func positionFieldAndCulturalPracticeButton() {
        let viewButton = UIView(frame: .zero)
        viewButton.translatesAutoresizingMaskIntoConstraints = false
        viewButton.addSubview(fieldButton)
        viewButton.addSubview(culturalPracticeButton)
        addSubview(viewButton)
        
        NSLayoutConstraint.activate([
            fieldButton.centerYAnchor.constraint(equalTo: viewButton.centerYAnchor),
            fieldButton.leadingAnchor.constraint(equalTo: viewButton.leadingAnchor),
            fieldButton.heightAnchor.constraint(equalTo: viewButton.heightAnchor, multiplier: 0.8),
            culturalPracticeButton.centerYAnchor.constraint(equalTo: viewButton.centerYAnchor),
            culturalPracticeButton.trailingAnchor.constraint(equalTo: viewButton.trailingAnchor),
            culturalPracticeButton.heightAnchor.constraint(equalTo: viewButton.heightAnchor, multiplier: 0.8),
            viewButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            viewButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            viewButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1),
            fieldButton.widthAnchor.constraint(equalTo: viewButton.widthAnchor, multiplier: 0.4),
            culturalPracticeButton.widthAnchor.constraint(equalTo: viewButton.widthAnchor, multiplier: 0.4)
            
        ])
    }
    
}
