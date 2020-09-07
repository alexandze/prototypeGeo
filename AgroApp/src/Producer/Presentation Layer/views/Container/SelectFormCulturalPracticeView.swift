//
//  CuturalPracticeFormView.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class SelectFormCulturalPracticeView: UIView {

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
        button.backgroundColor =  Util.getGreenColor()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleButtonValidate(_:)), for: .touchUpInside)
        return button
    }()

    let labelDetail: UILabel = {
        let label = UILabel()
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    let alert: UIAlertController = {
        return UIAlertController(
            title: NSLocalizedString(
                "Voulez-vous enregistrer la valeur choisie ?",
                comment: "Voulez-vous enregistrer la valeur choisie ?"
            ),
            message: nil,
            preferredStyle: .alert
        )
    }()

    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    var textTitle: String? {
        didSet {
            headerPresentedView.textTitle = textTitle ?? ""
        }
    }

    var textDetail: String? {
        didSet {
            labelDetail.text = textDetail
        }
    }

    var handleButtonValidateFunc: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        configView()
        addSubviewToParentView()
        initConstraintHeaderPresentedView()
        initButtonValidate()
        initConstraintScrollView()
        initPickerView()
        initLabelDetail()
    }

    func initHandleCloseButton(_ handleCloseFunc: @escaping () -> Void) {
        self.headerPresentedView.handleCloseButtonWith(handleCloseFunc)
    }

    func initHandleValidateButton(_ handleValidateFunc: @escaping () -> Void) {
        self.handleButtonValidateFunc = handleValidateFunc
    }

    func initAlertAction(_ handleYesAction: @escaping () -> Void, _ handleNoAction: @escaping () -> Void) {
        let alertActionYes = createAlertActionYes {
            handleYesAction()
        }

        let alertActionNo = createAlertActionNo {
            handleNoAction()
        }

        alert.addAction(alertActionYes)
        alert.addAction(alertActionNo)
    }

    func getLabelForPickerView(text: String, widthPickerView: CGFloat) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: widthPickerView * 0.9, height: 60))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.font =  label.font.withSize(15)
        label.sizeToFit()
        return label
    }

    func reuseLabelPickerView(label: UILabel, text: String) -> UILabel {
        label.text = text
        label.sizeToFit()
        return label
    }

    private func createAlertActionYes(handleFunc: @escaping () -> Void) -> UIAlertAction {
        let alertAction = UIAlertAction(
            title: NSLocalizedString("Oui", comment: "Oui"),
            style: .default,
            handler: { _ in handleFunc() }
        )

        // alertAction.setValue(UIColor.green, forKey:  "titleTextColor")
        return alertAction
    }

    private func createAlertActionNo(handleFunc: @escaping () -> Void) -> UIAlertAction {
        let alertAction = UIAlertAction(
            title: NSLocalizedString("Non", comment: "Non"),
            style: .default,
            handler: {_ in handleFunc() }
        )

        // alertAction.setValue(UIColor.red, forKey:  "titleTextColor")
        return alertAction
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
            scrollView.bottomAnchor.constraint(equalTo: buttonValidate.topAnchor)
        ])
    }

    private func initLabelDetail() {
        scrollView.addSubview(labelDetail)

        NSLayoutConstraint.activate([
            labelDetail.bottomAnchor.constraint(equalTo: pickerView.topAnchor, constant: 50),
            labelDetail.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            labelDetail.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7)
        ])
    }

   private func initPickerView() {
        scrollView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pickerView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            pickerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            //pickerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.20),
            pickerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7)
        ])
    }

    private func initButtonValidate() {
        addSubview(buttonValidate)

        NSLayoutConstraint.activate([
            buttonValidate.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.09),
            buttonValidate.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            buttonValidate.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10),
            buttonValidate.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc private func handleButtonValidate(_ buttonValidate: UIButton) {
        handleButtonValidateFunc?()
    }

    private func configView() {
        backgroundColor = Util.getBackgroundColor()
        alpha = Util.getAlphaValue()
    }
}
