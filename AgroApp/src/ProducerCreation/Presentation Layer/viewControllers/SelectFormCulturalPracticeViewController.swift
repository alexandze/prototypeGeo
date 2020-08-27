//
//  CulturalPracticeFormViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class SelectFormCulturalPracticeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var selectFormCulturalPracticeViewModel: SelectFormCulturalPracticeViewModel
    let selectFormCulturalPracticeView = SelectFormCulturalPracticeView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(culturalPracticeFormViewModel: SelectFormCulturalPracticeViewModel) {
        self.selectFormCulturalPracticeViewModel = culturalPracticeFormViewModel
        super.init(nibName: nil, bundle: nil)
    }

    public override func loadView() {
        self.view = selectFormCulturalPracticeView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isModalInPresentation = true
        
        selectFormCulturalPracticeView.initHandleCloseButton { [weak self] in
            self?.selectFormCulturalPracticeViewModel.handleCloseButton()
        }
        
        selectFormCulturalPracticeView.initHandleValidateButton { [weak self] in
            self?.selectFormCulturalPracticeViewModel.handleValidateButton()
        }
        
        selectFormCulturalPracticeView.initAlertAction(
            selectFormCulturalPracticeViewModel.handleYesButtonAlert,
            selectFormCulturalPracticeViewModel.handleNoButtonAlert
        )
        
        selectFormCulturalPracticeViewModel.getSelectedRow = { [weak self] in
            self?.selectFormCulturalPracticeView.pickerView.selectedRow(inComponent: 1) ?? 0
        }
        
        selectFormCulturalPracticeViewModel.setSelectedRow = { [weak self] row in
            self?.selectFormCulturalPracticeView.pickerView.selectRow(row, inComponent: 1, animated: true)
        }
        
        selectFormCulturalPracticeViewModel.reloadPickerView = { [weak self] in
            self?.selectFormCulturalPracticeView.pickerView.reloadAllComponents()
        }
        
        selectFormCulturalPracticeViewModel.setTitleText = { [weak self] title in
            self?.selectFormCulturalPracticeView.textTitle = title
        }
        
        selectFormCulturalPracticeViewModel.setDetailText = { [weak self] detailText in
            self?.selectFormCulturalPracticeView.textDetail = detailText
        }
        
        selectFormCulturalPracticeViewModel.dismissViewController = {[weak self] in
            self?.dismiss(animated: true)
        }
        
        self.selectFormCulturalPracticeViewModel.printAlert = {[weak self] in
            guard let self = self else {
                return
            }
            
            self.present(self.selectFormCulturalPracticeView.alert, animated: true)
        }
        
        selectFormCulturalPracticeViewModel.subscribeToCulturalPracticeFormObs()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectFormCulturalPracticeViewModel.disposeToCulturalPracticeFormObs()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        selectFormCulturalPracticeViewModel.getNumberOfRows()
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        45
    }

    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        self.selectFormCulturalPracticeView.pickerView.frame.size.width
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let label = view as? UILabel {
            return selectFormCulturalPracticeView.reuseLabelPickerView(
                label: label,
                text: selectFormCulturalPracticeViewModel.getValueByRow(row) ?? ""
            )
        }
        
        return selectFormCulturalPracticeView.getLabelForPickerView(
            text: selectFormCulturalPracticeViewModel.getValueByRow(row) ?? "",
            widthPickerView: selectFormCulturalPracticeView.pickerView.frame.width
        )
    }
}
