//
//  SelectedFieldRightCalloutView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-04.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class SelectedFieldCalloutView: UIView {
    static let tagButtonCancel = 51
    static let tagButttonAdd = 50
    
    private var handleButtonCancelFunc: ((UIButton) -> Void)?
    private var handleButtonAddFunc: ((UIButton) -> Void)?
    
    let buttonAdd: UIButton = {
        let buttonAdd = UIButton()
        let addImage = UIImage(named: "plus")
        buttonAdd.setImage(addImage, for: .normal)
        buttonAdd.tag = tagButttonAdd
        buttonAdd.translatesAutoresizingMaskIntoConstraints = false
        return buttonAdd
    }()
    
    let buttonCancel: UIButton = {
        let buttonCancel = UIButton()
        let cancelImage = UIImage(named: "stop")
        buttonCancel.setImage(cancelImage, for: .normal)
        buttonCancel.tag = tagButtonCancel
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false
        return buttonCancel
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        initView()
    }
    
    
    
    public func addTargetHandleForButtonCancel(_ handleButtonCancelFunc: @escaping (UIButton) -> Void) {
        self.handleButtonCancelFunc = handleButtonCancelFunc
        buttonCancel.addTarget(self, action: #selector(handleButtonCancel(sender:)), for: .touchDown)
    }
    
    public func addTargetHandleForButtonAdd(_ handleButtonAddFunc: @escaping (UIButton) -> Void) {
        self.handleButtonAddFunc = handleButtonAddFunc
        buttonAdd.addTarget(self, action: #selector(handleButtonAdd(sender:)), for: .touchDown)
    }
    
    
    public func setStateButton(isSelected: Bool) {
        buttonCancel.isHidden = !isSelected
        buttonAdd.isHidden = isSelected
    }
    
    private func initView() {
        addSubview(buttonAdd)
        addSubview(buttonCancel)
        buttonCancel.isHidden = true
        buttonAdd.isHidden = false
        centerButtonInView(button: buttonAdd)
        centerButtonInView(button: buttonCancel)
    }
    
    @objc private func handleButtonCancel(sender: UIButton) {
        handleButtonCancelFunc.map {
            $0(sender)
        }
    }
    
    @objc private func handleButtonAdd(sender: UIButton) {
        handleButtonAddFunc.map {
            $0(sender)
        }
    }
    
    private func centerButtonInView(button: UIButton) {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
