//
//  InputFormCulturalPractice.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI
import RxSwift

struct InputFormCulturalPracticeView: View {
    let viewModel: InputFormCulturalPracticeViewModel
    @ObservedObject var viewState: InputFormCulturalPracticeViewModelImpl.ViewState
    @ObservedObject var keyboardFollower: KeyboardFollower
    var disposableDismissForm: Disposable?
    
    init(
        viewModel: InputFormCulturalPracticeViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = viewModel
        self.viewState = viewModel.viewState
        self.keyboardFollower = keyboardFollower
    }
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            
            VStack {
                if self.viewState.inputElementObservale != nil {
                    HeaderView(title: self.viewState.inputElementObservale.title) { self.viewModel.handleCloseButton() }
                    Spacer()
                    
                    CenterView(
                        inputValue: self.$viewState.inputElementObservale.value,
                        inputTitle: self.viewState.inputElementObservale.title,
                        subtitle: self.viewState.inputElementObservale.subtitle ?? "",
                        isInputValueValid: self.viewState.inputElementObservale.isValid,
                        unitType: self.viewState.inputElementObservale.unitType ?? "",
                        textButtonValidate: self.viewState.textButtonValidate,
                        textErrorMessage: self.viewState.textErrorMessage
                    ) {
                        self.viewModel.handleButtonValidate()
                    }.padding()
                    
                    if self.keyboardFollower.keyboardHeight == 0 {
                        Spacer()
                    }
                    
                    ButtonValidate(
                        textButtonValidate: self.viewState.textButtonValidate,
                        actionValidateButton: {self.viewModel.handleButtonValidate()},
                        isInputValueValid: self.viewState.inputElementObservale.isValid
                    ).padding(.bottom, 5)
                        .padding(.bottom, self.keyboardFollower.keyboardHeight)
                }
                
            }
            .environmentObject(DimensionScreen(width: geometry.size.width, height: geometry.size.height))
            .onAppear {
                self.viewModel.configView()
                self.viewModel.subscribeToInputFormCulturalPracticeStateObs()
            }
            .onDisappear {
                self.viewModel.disposeToObs()
            }.animation(.default)
                .alert(isPresented: self.$viewState.isPrintAlert) {
                    Alert(
                        title: Text(self.viewState.textAlert),
                        message: Text(""),
                        primaryButton: .cancel(
                            Text("Oui"),
                            action: { self.viewModel.handleAlertYesButton() }
                        ),
                        secondaryButton: .default(
                            Text("Non"),
                            action: { self.viewModel.handleAlertNoButton() }
                        )
                    )
            }
        }
    }
}

private struct HeaderView: View {
    var title: String
    var actionCloseButton: () -> Void
    @EnvironmentObject var dimensionScreen: DimensionScreen
    
    var body: some View {
        HStack(alignment: .top) {
            UIButtonRepresentable { self.actionCloseButton() }
                .fixedSize()
                .offset(x: 5, y: 5)
            
            Spacer()
            
            Text(title)
                .font(.system(size: 25))
                .bold()
                .frame(width: dimensionScreen.width * 0.7, alignment: .center)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .offset(x: -15, y: 10)
            
            Spacer()
        }
    }
}

private struct CenterView: View {
    @Binding var inputValue: String
    let inputTitle: String
    let subtitle: String
    let isInputValueValid: Bool
    let unitType: String
    let textButtonValidate: String
    let textErrorMessage: String
    let actionValidateButton: () -> Void
    @EnvironmentObject var dimensionScreen: DimensionScreen
    
    var body: some View {
        VStack {
            Text(subtitle)
                .font(.system(size: 15))
                .bold()
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            TextFieldWithStyle(inputValue: $inputValue, inputTitle: inputTitle, isValid: isInputValueValid)
        }
    }
    
    func getWidthValidateButton() -> CGFloat {
        dimensionScreen.width * 0.6
    }
    
    func getHeightValidateButton() -> CGFloat {
        dimensionScreen.height * 0.09
    }
}

private struct TextFieldWithStyle: View {
    @Binding var inputValue: String
    let inputTitle: String
    var isValid: Bool
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dimensionScreen: DimensionScreen
    
    var body: some View {
        TextField(inputTitle, text: $inputValue)
            .keyboardType(.numbersAndPunctuation)
            .font(.system(size: 25))
            .padding(.horizontal, 10)
            .frame(
                width: self.dimensionScreen.width * 0.3,
                height: (self.dimensionScreen.height * 0.1),
                alignment: .center
        )
            .background(colorScheme == .dark ? Color.black : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 2)
                    .foregroundColor(self.getForegroundColorOfRoundedRectangle())
        )
    }
    
    private func getForegroundColorOfRoundedRectangle() -> Color {
        self.isValid ? .green : .red
    }
}

private struct ButtonValidate: View {
    let textButtonValidate: String
    let actionValidateButton: () -> Void
    let isInputValueValid: Bool
    @EnvironmentObject var dimensionScreen: DimensionScreen
    
    var body: some View {
        Button(action: { self.actionValidateButton()  }) {
            Text(textButtonValidate)
                .frame(
                    minWidth: self.getWidthValidateButton(),
                    idealWidth: self.getWidthValidateButton(),
                    maxWidth: self.getWidthValidateButton(),
                    minHeight: self.getHeightValidateButton(),
                    idealHeight: self.getHeightValidateButton(),
                    maxHeight: self.getHeightValidateButton(),
                    alignment: .center
            )
        }
        .frame(
            width: self.getWidthValidateButton(),
            height: self.getHeightValidateButton(),
            alignment: .center
        )
            .foregroundColor(.white)
            .background(self.getBackgroundColor())
            .cornerRadius(10)
            .disabled(!self.isInputValueValid)
    }
    
    func getWidthValidateButton() -> CGFloat {
        dimensionScreen.width * 0.6
        
    }
    
    func getHeightValidateButton() -> CGFloat {
        dimensionScreen.height * 0.09
    }
    
    private func getBackgroundColor() -> Color {
        self.isInputValueValid ? Color(Util.getGreenColor()) : .red
    }
}
