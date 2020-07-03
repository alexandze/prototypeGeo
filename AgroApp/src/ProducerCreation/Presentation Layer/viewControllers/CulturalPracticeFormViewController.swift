//
//  CulturalPracticeFormViewController.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class CulturalPracticeFormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var culturalPracticeFormViewModel: SelectFormCulturalPracticeViewModel
    let culturalPracticeFormView = CuturalPracticeFormView()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(culturalPracticeFormViewModel: SelectFormCulturalPracticeViewModel) {
        self.culturalPracticeFormViewModel = culturalPracticeFormViewModel
        super.init(nibName: nil, bundle: nil)
        self.culturalPracticeFormViewModel.viewController = self
    }

    public override func loadView() {
        self.view = culturalPracticeFormView
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        culturalPracticeFormViewModel.subscribeToCulturalPracticeFormObs()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        culturalPracticeFormViewModel.disposeToCulturalPracticeFormObs()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        culturalPracticeFormViewModel.pickerView(numberOfRowsInComponent: component)
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        90
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        culturalPracticeFormViewModel.pickerView(pickerView: pickerView, viewForRow: row, forComponent: component, reusingView: view)
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.culturalPracticeFormViewModel.dispatchFormIsDirty()
    }
}
