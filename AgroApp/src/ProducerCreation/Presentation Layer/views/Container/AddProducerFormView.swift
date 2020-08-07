//
//  AddProducerFormView.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-08-06.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

struct AddProducerFormView: View {
    let viewModel: AddProducerFormViewModel
    let keyboardFollower: KeyboardFollower

    init(
        addProducerFormViewModel: AddProducerFormViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = addProducerFormViewModel
        self.keyboardFollower = keyboardFollower
    }

    var body: some View {
        VStack {
            Text("Add Producer")
        }.onAppear {
            self.viewModel.configView()
            self.viewModel.subscribeToStateObservable()
        }
        .onDisappear {
            self.viewModel.dispose()
        }
    }
}
