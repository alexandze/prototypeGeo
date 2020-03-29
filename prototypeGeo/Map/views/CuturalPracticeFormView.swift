//
//  CuturalPracticeFormView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class CuturalPracticeFormView: UIView {
    
    let headerPresentedView: HeaderPresentedView = {
        let headerPresentedView = HeaderPresentedView()
        headerPresentedView.translatesAutoresizingMaskIntoConstraints = false
        return headerPresentedView
    }()
    
    let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let buttonValidate: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("Valider", comment: "Valider button"), for: .normal)
        button.backgroundColor =  UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let labelDetail: UILabel = {
        let label = UILabel()
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    public var textTitle: String? {
        didSet {
            headerPresentedView.textTitle = textTitle!
        }
    }
    
    public var textDetail: String? {
        didSet {
            labelDetail.text = textDetail
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        configView()
        addSubviewToParentView()
        initConstraintHeaderPresentedView()
        initConstraintScrollView()
    }
    
    private func addSubviewToParentView() {
        addSubview(headerPresentedView)
        addSubview(scrollView)
    }
    
    private func initConstraintHeaderPresentedView() {
        NSLayoutConstraint.activate([
            headerPresentedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerPresentedView.topAnchor.constraint(equalTo: topAnchor),
            headerPresentedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerPresentedView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func initConstraintScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerPresentedView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func initLabelDetail(pickerView: UIPickerView) {
        scrollView.addSubview(labelDetail)
        
        NSLayoutConstraint.activate([
            labelDetail.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 20),
            labelDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            labelDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    func initPickerView(pickerView: UIPickerView) {
        scrollView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -80),
            pickerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            pickerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.25),
            pickerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.8)
        ])
        initLabelDetail(pickerView: pickerView)
        initButtonValidate(pickerView: pickerView)
    }
    
    private func initButtonValidate(pickerView: UIPickerView) {
        scrollView.addSubview(buttonValidate)
        
        NSLayoutConstraint.activate([
            buttonValidate.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 50),
            buttonValidate.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            buttonValidate.heightAnchor.constraint(equalToConstant: 50),
            buttonValidate.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7)
        ])
    }
    
    func handleCloseButton(_ handleCloseFunc: @escaping () -> Void) {
        self.headerPresentedView.handleCloseButtonWith(handleCloseFunc)
    }
    
    private func configView() {
        backgroundColor = Util.getBackgroundColor()
        alpha = Util.getAlphaValue()
    }
}
