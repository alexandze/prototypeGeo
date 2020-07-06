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
        self.selectFormCulturalPracticeViewModel.viewController = self
    }

    public override func loadView() {
        self.view = selectFormCulturalPracticeView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        selectFormCulturalPracticeViewModel.pickerView(numberOfRowsInComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        90
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        selectFormCulturalPracticeViewModel.pickerView(pickerView: pickerView, viewForRow: row, forComponent: component, reusingView: view)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectFormCulturalPracticeViewModel.dispatchFormIsDirty()
    }
}
