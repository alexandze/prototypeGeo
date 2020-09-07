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
            segmentedController.titleForSegment(at: 0)
        }
        set(title) {
            segmentedController.setTitle(title, forSegmentAt: 0)
        }
    }

    var titleCulturalPracticeButton: String? {
        get {
            segmentedController.titleForSegment(at: 1)
        }

        set(title) {
            segmentedController.setTitle(title, forSegmentAt: 1)
        }
    }

    private let tagCulturalPracticeButton = 50
    private let tagFieldButton = 51
    private var actionFieldButton: (() -> Void)?
    private var actionCulturalPracticeButton: (() -> Void)?
    
    private let segmentedController: UISegmentedControl =  {
        let segmentedController = UISegmentedControl(items: ["Parcelle", "Pratique Culturelle"])
        segmentedController.translatesAutoresizingMaskIntoConstraints = false
        return segmentedController
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.positionSegmentedController()
        self.initTargetSegmentedController()
        self.initSelectedSegmentIndex()
    }

    func initHandleFieldButton(handleFunc: @escaping () -> Void) {
        actionFieldButton = handleFunc
    }

    func initHandleCulturalPracticeButton(handleFunc: @escaping () -> Void) {
        actionCulturalPracticeButton = handleFunc
    }
    
    @objc private func handleValueChangeSengmentedController(_ segmentedController: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            actionFieldButton?()
        case 1:
            actionCulturalPracticeButton?()
        default:
            break
        }
    }
    
    private func positionSegmentedController() {
        addSubview(segmentedController)
        
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: topAnchor),
            segmentedController.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedController.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedController.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func initTargetSegmentedController() {
        segmentedController.addTarget(self, action: #selector(handleValueChangeSengmentedController(_:)), for: .valueChanged)
    }
    
    private func initSelectedSegmentIndex() {
        segmentedController.selectedSegmentIndex = 0
    }
}
