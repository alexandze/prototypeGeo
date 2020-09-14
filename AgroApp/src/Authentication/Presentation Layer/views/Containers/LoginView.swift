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
    @ObservedObject var keyboardFollower: KeyboardFollower
    @ObservedObject var viewState: LoginViewModelImpl.ViewState
    
    init(
        loginViewModel: LoginViewModel,
        viewState: LoginViewModelImpl.ViewState,
        keyboardFollower: KeyboardFollower = KeyboardFollower()
    ) {
        self.loginViewModel = loginViewModel
        self.keyboardFollower = keyboardFollower
        self.viewState = viewState
    }
    
    var body: some View {
        GeometryReader { (geometryProxy: GeometryProxy) in
            
            VStack {
                if self.viewState.isprint {
                    ScrollView {
                        VStack {
                            Text("AgroApp")
                                .font(.system(size: 45))
                                .bold()
                                .italic()
                                .padding()
                            ForEach(self.viewState.elementUIDataObservableList, id: \.id) { (elementUIData: ElementUIDataObservable) in
                                VStack {
                                    if self.isInputElement(elementUIData) {
                                        InputWithTitleElement(inputElement: (elementUIData as! InputElementObservable))
                                            .padding(15)
                                    }
                                }
                            }
                            
                            if self.isKeyboardVisible() {
                                ButtonValidate(title: "Connexion", isButtonActivated: true) {
                                    self.loginViewModel.handleConnexionButton()
                                }
                            }

                        }
                    }.frame(
                        width: geometryProxy.size.width * 0.9,
                        height: self.isKeyboardVisible()
                            ? self.calculHeightWithKeyBoard(geometryProxy: geometryProxy)
                            : self.calculHeightWithoutKeyBoard(geometryProxy: geometryProxy),
                        alignment: .top
                    )
                }
                
                Spacer()
                
                if !self.isKeyboardVisible() {
                    ButtonValidate(title: "Connexion", isButtonActivated: true) {
                        self.loginViewModel.handleConnexionButton()
                    }.padding(.bottom, 5)
                }
                
            }.onAppear {
                self.loginViewModel.configView()
                self.loginViewModel.subscribeToStateObservable()
            }
            .onDisappear {
                self.loginViewModel.disposes()
            }.animation(.default)
            .environmentObject( DimensionScreen(width: geometryProxy.size.width, height: geometryProxy.size.height))
            
        }
        
    }
    
    private func isInputElement(_ elementUIData: ElementUIDataObservable) -> Bool {
        elementUIData.type == InputElementObservable.TYPE_ELEMENT &&
            (elementUIData as? InputElementObservable) != nil
    }
    
    private func calculHeightWithKeyBoard(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height - keyboardFollower.keyboardHeight
    }
    
    private func calculHeightWithoutKeyBoard(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height * 0.85
    }
    
    private func isKeyboardVisible() -> Bool {
        keyboardFollower.isVisible
    }
}

private struct InputWithTitleElement: View {
    @ObservedObject var inputElement: InputElementDataObservable
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Text("\(self.inputElement.title)")
                Spacer()
            }
            
            HStack {
                ZStack {
                    if self.isTitleValuePassword() {
                        self.getPasswordTextField()
                    } else {
                        self.getNormalTextField()
                    }
                    
                    HStack {
                        Spacer()
                        
                        if self.inputElement.isValid {
                            getValidImage()
                        }
                        
                        if !self.inputElement.isValid && self.inputElement.isRequired {
                            getNoValidImage()
                        }
                        
                        if !self.inputElement.isValid && !self.inputElement.isRequired {
                            getWarningImage().padding(.trailing, 5)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func getForegroundColorOfRoundedRectangle() -> Color {
        self.inputElement.isValid
            ? .green
            : .red
    }
    
    private func isTitleValuePassword() -> Bool {
        inputElement.typeValue == "password"
    }
    
    private func getPasswordTextField() -> some View {
        SecureField(
            "",
            text: $inputElement.value
        )//.keyboardType(self.inputElement.keyboardType.getUIKeyboardType())
            .padding(
                EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
        ).background(colorScheme == .dark ? Color.black : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 2)
                    .foregroundColor(self.getForegroundColorOfRoundedRectangle())
        )
    }
    
    private func getNormalTextField() -> some View {
        TextField(
            "",
            text: $inputElement.value
        )//.keyboardType(self.inputElement.keyboardType.getUIKeyboardType())
            .padding(
                EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
        ).background(colorScheme == .dark ? Color.black : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 2)
                    .foregroundColor(self.getForegroundColorOfRoundedRectangle())
        )
    }
}

private struct ButtonValidate: View {
    var title: String
    var isButtonActivated: Bool
    var action: () -> Void
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        Button(action: {
            self.action()
        }) {
            Text(title)
                .frame(
                    width: dimensionScreen.width * 0.6,
                    height: dimensionScreen.height * 0.09
            )
        }.disabled(!isButtonActivated)
            .frame(
                width: dimensionScreen.width * 0.6,
                height: dimensionScreen.height * 0.09
        ).foregroundColor(.white)
            .background(self.getBackgroundColor())
            .cornerRadius(10)
    }

    private func getBackgroundColor() -> Color {
        isButtonActivated ? Color(Util.getGreenColor()) : .red
    }
}

private func getValidImage() -> some View {
    Image("yes48")
        .resizable()
        .frame(width: 35, height: 35)
}

private func getNoValidImage() -> some View {
    Image("no48")
        .resizable()
        .frame(width: 35, height: 35)
}

private func getRemoveImage() -> some View {
    Image("stop")
        .resizable()
        .frame(width: 35, height: 35)
}

private func getWarningImage() -> some View {
    Image("warning")
        .resizable()
        .frame(width: 35, height: 35)
}
