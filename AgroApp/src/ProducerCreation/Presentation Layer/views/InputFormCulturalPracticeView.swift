//
//  InputFormCulturalPractice.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI
import RxSwift

struct InputFormCulturalPracticeView: View, SettingViewControllerProtocol {
    var dismiss: ((FuncVoid) -> Void)?
    var setAlpha: ((CGFloat) -> Void)?
    var setBackgroundColor: ((UIColor) -> Void)?
    var setIsModalInPresentation: ((Bool) -> Void)?
    var value: Bool?
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
                HeaderView(title: self.viewState.title) { self.viewModel.handleCloseButton() }
                Spacer()

                CenterView(
                    inputValue: self.$viewState.inputValue,
                    inputTitle: self.viewState.inputTitle,
                    subtitle: self.viewState.subTitle,
                    isInputValueValid: self.isInputValueValid,
                    unitType: self.viewState.unitType,
                    textButtonValidate: self.viewState.textButtonValidate,
                    textErrorMessage: self.viewState.textErrorMessage
                ) {
                    self.viewModel.handleButtonValidate()
                }
                .padding(.bottom, self.keyboardFollower.keyboardHeight)
                .edgesIgnoringSafeArea(
                    self.keyboardFollower.isVisible ? .bottom : []
                )
                    .animation(self.viewState.hasAnimation ? .default : nil)

                Spacer()
            }
            .environmentObject(DimensionScreen(width: geometry.size.width, height: geometry.size.height))
            .onAppear {
                self.configViewController()
                self.viewModel.subscribeToInputFormCulturalPracticeStateObs()
            }
            .onDisappear {
                self.viewModel.disposeToObs()
            }
            .alert(isPresented: self.$viewState.isPrintAlert) {
                Alert(
                    title: Text(self.viewState.textAlert),
                    message: Text(""),
                    primaryButton: .cancel(
                        Text("Oui").foregroundColor(.green),
                        action: { self.viewModel.handleAlertYesButton() }
                    ),
                    secondaryButton: .default(
                        Text("Non").foregroundColor(.red),
                        action: { self.viewModel.handleAlertNoButton() }
                    )
                )
            }
            .onReceive(self.viewState.$isDismissForm, perform: self.dismissForm(isDismissForm:))
        }
    }

    func configViewController() {
        self.setBackgroundColor?(Util.getBackgroundColor())
        self.setAlpha?(Util.getAlphaValue())
        self.setIsModalInPresentation?(true)
    }

    func dismissForm(isDismissForm: Bool) {
        if isDismissForm {
            self.dismiss? { }
        }
    }

    var isInputValueValid: Bool {
        return viewModel.isInputValueValid(viewState.inputValue)
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
                .padding(.bottom, 10)

            TextFieldWithStyle(inputValue: $inputValue, inputTitle: inputTitle)
                .padding(.bottom, 10)

            Button(action: { self.actionValidateButton() }) {
                Text(textButtonValidate)
                    .frame(
                        minWidth: getWidthValidateButton(),
                        idealWidth: getWidthValidateButton(),
                        maxWidth: getWidthValidateButton(),
                        minHeight: getHeightValidateButton(),
                        idealHeight: getHeightValidateButton(),
                        maxHeight: getHeightValidateButton(),
                        alignment: .center
                )
            }
            .frame(
                width: getWidthValidateButton(),
                height: getHeightValidateButton(),
                alignment: .center
            )
                .foregroundColor(.white)
                .background(Color(UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)))
                .cornerRadius(10)
                .disabled(!self.isInputValueValid)

            if !self.isInputValueValid {
                Text(textErrorMessage)
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding(.top)
            }
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
            .cornerRadius(5)
    }
}
