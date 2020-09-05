//
//  LoginView.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    let loginViewModel: LoginViewModel
    let keyboardFollower: KeyboardFollower
    
    init(
        loginViewModel: LoginViewModel,
        keyboardFollower: KeyboardFollower = KeyboardFollower()
    ) {
        self.loginViewModel = loginViewModel
        self.keyboardFollower = keyboardFollower
    }
    
    var body: some View {
        Button(action: {
            self.loginViewModel.handleConnexionButton()
        }) {
            Text("Connexion")
        }
    }
}
