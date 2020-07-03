//
//  InputFormCulturalPractice.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

struct InputFormCulturalPracticeView: View, SettingViewControllerProtocol {
    var dismiss: ((FuncVoid) -> Void)?
    var setAlpha: ((CGFloat) -> Void)?
    var setBackgroundColor: ((UIColor) -> Void)?
    var setIsModalInPresentation: ((Bool) -> Void)?
    let viewModel: InputFormCulturalPracticeViewModel
    let viewState: InputFormCulturalPracticeViewModelImpl.ViewState

    init(viewModel: InputFormCulturalPracticeViewModel) {
        self.viewModel = viewModel
        self.viewState = viewModel.viewState
    }

    var body: some View {
        VStack {
            Spacer()
            Text("View cutural practice")
            TextField(viewState.inputTitle, text: viewState.$inputValue)
            Button(action: { self.dismiss!({}) }) {
                Text("Dismiss controller")
            }
            Spacer()
        }.onAppear {
            self.configViewController()
        }
    }

    func configViewController() {
        self.setBackgroundColor?(Util.getBackgroundColor())
        self.setAlpha?(Util.getAlphaValue())
        self.setIsModalInPresentation?(true)
    }
}

/*
struct InputFormCulturalPractice_Previews: PreviewProvider {
    static var previews: some View {
       // InputFormCulturalPracticeView()
    }
}
*/
