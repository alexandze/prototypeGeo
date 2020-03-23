//
//  FieldListViewModel.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-02-28.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import RxSwift

class FieldListViewModelImpl: FieldListViewModel {

    let fieldListStateObs: Observable<FieldListState>
    let actionDispatcher: ActionDispatcher
    var disposableFieldListState: Disposable?
    var fieldList: [FieldType] = []
    var tableView: UITableView?
    var viewController: UIViewController?

    init(
        fieldListStateObs: Observable<FieldListState>,
        actionDispatcher: ActionDispatcher
    ) {
        self.fieldListStateObs = fieldListStateObs
        self.actionDispatcher = actionDispatcher
    }

    func subscribeToObservableFieldListState() {
        self.disposableFieldListState = fieldListStateObs
            .observeOn(MainScheduler.instance)
            .subscribe {
                if let state = $0.element {
                    if !state.isForRemove {
                        return self.insertRow(fieldListState: state)
                    }

                    self.deletedRow(fieldListState: state)
                }
        }
        
        let cul = CulturalPractice(avaloir: .absente, bandeRiveraine: .de1A3M, doseFumier: [.dose(quantite: 1), .dose(quantite: 2)], periodeApplicationFumier: [.automneHatif, .automneTardif], delaiIncorporationFumier: [.incorporeEn48H, .nonIncorpore], travailSol: .labourAutomneTravailSecondairePrintemps, couvertureAssociee: .vrai, couvertureDerobee: .faux, drainageSouterrain: .absent, drainageSurface: .bon, conditionProfilCultural: .presenceZoneRisques, tauxApplicationPhosphoreRang: .taux(10.5), tauxApplicationPhosphoreVolee: .taux(10), pMehlich3: .taux(15), alMehlich3: .taux(10), cultureAnneeEnCoursAnterieure: .mai)
        
        let test = CulturalPractice.getCulturalPracticeElement(culturalPractice: cul)
        print(test)
    }

    func dispose() {
        self.disposableFieldListState?.dispose()
    }

    func insertRow(fieldListState: FieldListState) {
        self.fieldList = fieldListState.fieldList
        tableView?.beginUpdates()
        self.tableView?.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        tableView?.endUpdates()
    }

    func deletedRow(fieldListState: FieldListState) {
        self.fieldList = fieldListState.fieldList
        let indexDeleted = fieldListState.indexForRemove
        tableView?.beginUpdates()
        self.tableView?.deleteRows(at: [IndexPath(row: indexDeleted, section: 0)], with: .top)
        tableView?.endUpdates()

    }

    func setTableView(tableView: UITableView) {
        self.tableView = tableView
    }
    
    public func handle(didSelectRowAt indexPath: IndexPath) {
        let currentFieldSelected = fieldList[indexPath.row]
        let action = MapFieldAction.SelectedFieldOnListAction(fieldType: currentFieldSelected)
        actionDispatcher.dispatch(action)
        
        
        let appDelegate = viewController!.getAppDelegate()
        appDelegate.map {
            viewController?.navigationController?.pushViewController($0.appDependencyContainer.processInitCulturalPracticeViewController(), animated: true)
        }
        
        
    }

}

protocol FieldListViewModel {
    func subscribeToObservableFieldListState()
    func dispose()
    func setTableView(tableView: UITableView)
    var fieldList: [FieldType] {get}
    var viewController: UIViewController? {get set}
    func handle(didSelectRowAt indexPath: IndexPath)
}
