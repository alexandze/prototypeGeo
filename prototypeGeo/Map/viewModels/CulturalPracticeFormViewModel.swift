//
//  CulturalPracticeFormViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class CulturalPracticeFormViewModelImpl: CulturalPracticeFormViewModel {
    let culturalPracticeFormObs: Observable<CulturalPracticeFormState>
    var disposableCulturalPracticeFormObs: Disposable?
    var viewController: UIViewController?
    var multiSelectElement: CulturalPracticeMultiSelectElement?
    var hasSubscribeToState = false
    
    init(culturalPracticeFormObs: Observable<CulturalPracticeFormState>) {
        self.culturalPracticeFormObs = culturalPracticeFormObs
    }
    
    func subscribeToCulturalPracticeFormObs() {
        if !hasSubscribeToState {
            hasSubscribeToState = true
            
            disposableCulturalPracticeFormObs = culturalPracticeFormObs.subscribe { event in
                guard let culturalPracticeElement = event.element?.culturalPraticeElement,
                    let fieldType = event.element?.fieldType,
                    let culturalPracticeFormStateSubAction = event.element?.culturalPracticeSubAction
                    else { return }
                
                if case CulturalPracticeFormSubAction.printAlert = culturalPracticeFormStateSubAction {
                    //TODO print Alert
                }
                
                if case CulturalPracticeFormSubAction.newDataForm = culturalPracticeFormStateSubAction {
                    self.handle(culturalPracticeElement: culturalPracticeElement, fieldType: fieldType)
                }
            }
        }
    }
    
    private func handle(culturalPracticeElement: CulturalPracticeElement, fieldType: FieldType) {
        switch culturalPracticeElement {
        case .culturalPracticeInputElement(let inputElement):
            //TODO init input view
            print(inputElement)
        case .culturalPracticeMultiSelectElement(let multiSelectElement):
            //TODO init multiSelectView
            handle(multiSelectElement: multiSelectElement, fieldType: fieldType)
        case .culturalPracticeInputMultiSelectContainer(let containerInputMultiSelect):
            print(containerInputMultiSelect)
        default:
            break
        }
    }
    
    private func handle(multiSelectElement: CulturalPracticeMultiSelectElement, fieldType: FieldType) {
        let formView = getCulturalPracticeFormView()
        self.multiSelectElement = multiSelectElement
        formView.textTitle = multiSelectElement.title
        
        switch fieldType {
        case .polygon(let polygon):
            formView.textDetail = "Choisir une valeur (\(multiSelectElement.title)) pour la parcelle \(polygon.id)"
        case .multiPolygon(let multipolygon):
            formView.textDetail = "Choisir une valeur (\(multiSelectElement.title)) pour la parcelle \(multipolygon.id)"
        }
        
        let pickerView = UIPickerView()
        pickerView.delegate = getCulturalPracticeFormController()
        pickerView.dataSource = getCulturalPracticeFormController()
        getCulturalPracticeFormView().initPickerView(pickerView: pickerView)
    }
    
    func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width * 0.9, height: 90))
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = self.multiSelectElement!.tupleCulturalTypeValue[row].1
        label.textColor = Util.getOppositeColorBlackOrWhite()
        label.sizeToFit()
        return label
    }
    
    func handle(numberOfRowsInComponent component: Int) -> Int {
        self.multiSelectElement!.tupleCulturalTypeValue.count
    }
    
    
    func handle(titleForRow row: Int) -> String {
        self.multiSelectElement!.tupleCulturalTypeValue[row].1
    }
    
    private func getCulturalPracticeFormView() -> CuturalPracticeFormView {
        (viewController as! CulturalPracticeFormViewController).culturalPracticeFormView
    }
    
    private func getCulturalPracticeFormController() -> CulturalPracticeFormViewController {
        viewController as! CulturalPracticeFormViewController
    }
    
    func disposeToCulturalPracticeFormObs() {
        disposableCulturalPracticeFormObs?.dispose()
    }
    
    func initHandleCloseButton() {
        if let formViewController = viewController as? CulturalPracticeFormViewController {
            formViewController.culturalPracticeFormView.handleCloseButton {
                //TODO afficher le modal pour sauvegarder ou pas
                self.viewController?.dismiss(animated: true)
            }
        }
    }
}

protocol CulturalPracticeFormViewModel {
    var viewController: UIViewController? {get set}
    func initHandleCloseButton()
    func subscribeToCulturalPracticeFormObs()
    func disposeToCulturalPracticeFormObs()
    func handle(numberOfRowsInComponent component: Int) -> Int
    func handle(titleForRow row: Int) -> String
    func handle(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
}
