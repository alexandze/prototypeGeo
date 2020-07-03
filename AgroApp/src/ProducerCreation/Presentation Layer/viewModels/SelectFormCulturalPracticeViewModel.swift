//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class SelectFormCulturalPracticeViewModelImpl: SelectFormCulturalPracticeViewModel {
    let culturalPracticeFormObs: Observable<SelectFormCulturalPracticeState>
    var disposableCulturalPracticeFormObs: Disposable?
    var disposableDispatcher: Disposable?
    var viewController: UIViewController?
    var multiSelectElement: CulturalPracticeMultiSelectElement?
    var fieldType: FieldType?
    var pickerView: UIPickerView?
    let actionDispatcher: ActionDispatcher

    init(
        culturalPracticeFormObs: Observable<SelectFormCulturalPracticeState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.culturalPracticeFormObs = culturalPracticeFormObs
        self.actionDispatcher = actionDispatcher
    }

    public func subscribeToCulturalPracticeFormObs() {
        self.initHandleCloseButton()
        self.disabledInteractiveDismissPresentedView()
        self.addAlertHandle()

        disposableCulturalPracticeFormObs = culturalPracticeFormObs
            .observeOn(MainScheduler.instance)
            .subscribe { event in
            guard let selectElement = event.element?.culturalPraticeElement as? CulturalPracticeMultiSelectElement,
                let fieldType = event.element?.fieldType,
                let culturalPracticeFormStateSubAction = event.element?.culturalPracticeSubAction
                else { return }
            self.setValues(selectElement: selectElement, fieldType: fieldType)

            switch culturalPracticeFormStateSubAction {
            case .newDataForm:
                self.handleNewFormData()
            case .printAlert:
                self.handlePrintAlert()
            case .formIsDirty:
                break
            case .closeWithSave:
                self.handleCloseWithSave()
            case .closeWithoutSave:
                self.handleCloseWithoutSave()
            }
        }
    }

    public func disabledInteractiveDismissPresentedView() {
        getCulturalPracticeFormViewController()!.isModalInPresentation = true
    }

    public func pickerView(numberOfRowsInComponent component: Int) -> Int {
        self.multiSelectElement!.tupleCulturalTypeValue.count
    }

    public func pickerView(titleForRow row: Int) -> String {
        self.multiSelectElement!.tupleCulturalTypeValue[row].1
    }

    public func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        if let labelReuse = view as? UILabel {
            return getCulturalPracticeFormView()!.reuseLabelPickerView(
                label: labelReuse,
                text: self.multiSelectElement!.tupleCulturalTypeValue[row].1
            )
        }

        return getCulturalPracticeFormView()!.getLabelForPickerView(
            text: self.multiSelectElement!.tupleCulturalTypeValue[row].1,
            widthPickerView: pickerView.frame.width
        )
    }

    public func disposeToCulturalPracticeFormObs() {
        disposableCulturalPracticeFormObs?.dispose()
        disposableDispatcher?.dispose()
    }

    private func presentedAlert(alertController: UIAlertController) {
        self.getCulturalPracticeFormViewController()!.present(alertController, animated: true)
    }

    private func initHandleValidateButton() {
        getCulturalPracticeFormView()!.handleValidateButton {
            self.dispatchClosePresentedViewControllerWithSave()
        }
    }

    private func closePresentedViewControllerWithoutSave() {
        self.dismissViewController()
    }

    private func dismissViewController() {
        self.getCulturalPracticeFormViewController()!.dismiss(animated: true)
    }

    private func createActionUpdateCulturalPracticeElementWith(selectElement: CulturalPracticeMultiSelectElement) -> CulturalPracticeListAction.UpdateCulturalPracticeElement {
        CulturalPracticeListAction.UpdateCulturalPracticeElement(culturalPracticeElementProtocol: selectElement)
    }

    private func setSelectElementWithCurrentValue(currentIndexChooseValue: Int) {
        self.multiSelectElement!.value = self.multiSelectElement!.tupleCulturalTypeValue[currentIndexChooseValue].0
    }

    private func getSelectedIndexOfPickerView() -> Int {
        self.pickerView!.selectedRow(inComponent: 0)
    }

    private func setPickerView(pickerView: UIPickerView) {
        self.pickerView = pickerView
    }

    private func setValues(selectElement: CulturalPracticeMultiSelectElement, fieldType: FieldType) {
        self.setSelectElement(selectElement: selectElement)
        self.setFieldType(fieldType: fieldType)
    }

    private func setSelectElement(selectElement: CulturalPracticeMultiSelectElement) {
        self.multiSelectElement = selectElement
    }

    private func setFieldType(fieldType: FieldType) {
        self.fieldType = fieldType
    }

    private func setTitle(_ title: String) {
        getCulturalPracticeFormView()!.textTitle = title
    }

    private func setTextDetailWith(fieldType: FieldType, and culturalPracticeElementProtocol: CulturalPracticeElementProtocol) {
        switch fieldType {
        case .polygon(let polygon):
            getCulturalPracticeFormView()!.textDetail =
                "Choisir une valeur (\(culturalPracticeElementProtocol.title)) pour la parcelle \(polygon.id)"
        case .multiPolygon(let multipolygon):
            getCulturalPracticeFormView()!.textDetail =
                "Choisir une valeur (\(culturalPracticeElementProtocol.title)) pour la parcelle \(multipolygon.id)"
        }
    }

    private func initPickerViewWith(selectElement: CulturalPracticeMultiSelectElement?) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = getCulturalPracticeFormViewController()
        pickerView.dataSource = getCulturalPracticeFormViewController()
        getCulturalPracticeFormView()!.initPickerView(pickerView: pickerView)
        return pickerView
    }

    private func initCurrentValueOfPickerView() {
        self.multiSelectElement?.value.map { valueElement in
            let firstIndex = type(of: valueElement).getValues()?.firstIndex { $0.0.getValue() == valueElement.getValue() }
            firstIndex.map { self.pickerView?.selectRow($0, inComponent: 0, animated: false) }
        }
    }

    private func getCulturalPracticeFormView() -> CuturalPracticeFormView? {
        (viewController as? CulturalPracticeFormViewController)?.culturalPracticeFormView
    }

    private func getCulturalPracticeFormViewController() -> CulturalPracticeFormViewController? {
        viewController as? CulturalPracticeFormViewController
    }
}

// extention handler methode
extension SelectFormCulturalPracticeViewModelImpl {
    private func handleNewFormData() {
        setTitle(self.multiSelectElement!.title)
        setTextDetailWith(fieldType: self.fieldType!, and: self.multiSelectElement!)
        setPickerView(pickerView: initPickerViewWith(selectElement: multiSelectElement))
        initCurrentValueOfPickerView()
        initHandleValidateButton()
    }

    private func handlePrintAlert() {
        presentedAlert(alertController: self.getCulturalPracticeFormView()!.alert)
    }

    private func handleCloseWithSave() {
        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.dispatchActionUpdateCulturalPracticeElement(action: self.createActionUpdateCulturalPracticeElementWith(selectElement: self.multiSelectElement!))
        }

        self.dismissViewController()
    }

    private func handleCloseWithoutSave() {
        self.dismissViewController()
    }

    private func initHandleCloseButton() {
        getCulturalPracticeFormView()!.handleCloseButton {
            self.dispatchClosePresentedViewController()
        }
    }

    private func addAlertHandle() {
        getCulturalPracticeFormView()?.addAlertAction(
            handleYesAction: {self.dispatchClosePresentedViewControllerWithSave()},
            handleNoAction: {self.dispatchClosePrensetedViewControllerWithoutSave()}
        )
    }
}

// extension for dispatcher methods
extension SelectFormCulturalPracticeViewModelImpl {
    public func dispatchFormIsDirty() {
        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(CulturalPracticeFormAction.SetFormIsDirtyAction(isDirty: true))
        }
    }

    private func dispatchClosePresentedViewControllerWithSave() {
        let indexSelected = self.getSelectedIndexOfPickerView()

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.ClosePresentedViewControllerWithSaveAction(indexSelected: indexSelected)
            )
        }
    }

    private func dispatchClosePrensetedViewControllerWithoutSave() {
        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.ClosePresentedViewControllerWithoutSaveAction()
            )
        }
    }

    private func dispatchClosePresentedViewController() {
        let indexSelected = self.getSelectedIndexOfPickerView()

        self.disposableDispatcher = Util.runInSchedulerBackground {
            self.actionDispatcher.dispatch(
                CulturalPracticeFormAction.ClosePresentedViewControllerAction(indexSelected: indexSelected)
            )
        }
    }

    private func dispatchActionUpdateCulturalPracticeElement(action: CulturalPracticeListAction.UpdateCulturalPracticeElement) {
        self.disposableDispatcher = Completable.create { completableEvent in
            self.actionDispatcher.dispatch(action)
            completableEvent(.completed)
            return Disposables.create()
        }.subscribeOn(Util.getSchedulerBackground())
        .subscribe()
    }
}

protocol SelectFormCulturalPracticeViewModel {
    var viewController: UIViewController? {get set}
    func subscribeToCulturalPracticeFormObs()
    func disposeToCulturalPracticeFormObs()
    func pickerView(numberOfRowsInComponent component: Int) -> Int
    func pickerView(titleForRow row: Int) -> String
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    func dispatchFormIsDirty()
}
