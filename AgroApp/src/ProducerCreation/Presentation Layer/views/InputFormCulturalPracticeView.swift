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
    @ObservedObject var keyboardFollower: KeyboardFollower

    init(
        viewModel: InputFormCulturalPracticeViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = viewModel
        self.viewState = viewModel.viewState
        self.keyboardFollower = keyboardFollower
    }

    var body: some View {
        VStack {
            HeaderView(title: "Alexandre andze") { self.dismiss? { } }
            Spacer()

            CenterView(inputValue: viewState.$inputValue, inputTitle: viewState.inputTitle, subtitle: viewState.subTitle) {
                // TODO action validate button
            }.padding(.bottom, keyboardFollower.keyboardHeight)
                .edgesIgnoringSafeArea(
                    keyboardFollower.isVisible ? .bottom : [])

            Spacer()
        }.onAppear {
            self.configViewController()
        }
    }

    func configViewController() {
        self.setBackgroundColor?(Util.getBackgroundColor())
        self.setAlpha?(1)
        self.setIsModalInPresentation?(true)
    }
}

private struct HeaderView: View {
    let title: String
    let actionCloseButton: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            UIButtonRepresentable { self.actionCloseButton() }
                .fixedSize()
                .offset(x: 5, y: 5)

            Spacer()

            Text(title)
                .font(.system(size: 25))
                .bold()
                .frame(width: 150, alignment: .center)
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .offset(y: 20)

            Spacer()
        }
    }
}

private struct CenterView: View {
    @Binding var inputValue: String
    let inputTitle: String
    let subtitle: String
    let actionValidateButton: () -> Void

    var body: some View {
        VStack {
            Text(subtitle)
                .font(.system(size: 20))
                .bold()
                .multilineTextAlignment(.center)

            TextFieldWithStyle(inputValue: $inputValue, inputTitle: inputTitle)

            Button(action: { self.actionValidateButton() }) {
                Text("Valider")
            }
                // .padding(.horizontal, 80)
                .frame(width: 200, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(Color(UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)))
                .cornerRadius(10)
        }
    }
}

private struct TextFieldWithStyle: View {
    @Binding var inputValue: String
    let inputTitle: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        TextField(inputTitle, text: $inputValue)
            .keyboardType(.decimalPad)
            .padding(.horizontal, 20)
            .frame(height: 80, alignment: .center)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(5)
            .padding(.horizontal, 90)
            .padding(.vertical, 10)
    }
}

/*
 struct InputFormCulturalPractice_Previews: PreviewProvider {
 static var previews: some View {
 InputFormCulturalPracticeView(viewModel: Util.getAppDependency()!.mapDependencyContainer.makeInputFormCulturalPracticeViewModel())
 }
 }
 */
