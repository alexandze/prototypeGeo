//
//  ContainerFormCulturalPracticeView.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-10.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import SwiftUI

struct ContainerFormCulturalPracticeView: View {
    let viewModel: ContainerFormCulturalPracticeViewModel
    @ObservedObject var viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState
    @ObservedObject var keyboardFollower: KeyboardFollower

    init(
        viewModel: ContainerFormCulturalPracticeViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = viewModel
        self.viewState = viewModel.viewState
        self.keyboardFollower = keyboardFollower
    }

    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            VStack {
                HeaderView(
                    title: self.viewState.titleForm,
                    actionCloseButton: { self.viewModel.handleButtonClose() }
                ).padding(.bottom, 20)

                Spacer()

                CenterView(viewState: self.viewState)

                Spacer()

                ButtonValidate(
                    isButtonActivated: self.viewState.isFormValid,
                    handleButton: { self.viewModel.handleButtonValidate() }
                ).padding(.bottom, 10)

            }.onAppear {
                self.viewModel.configView()
                self.viewModel.subscribeToStateObserver()
            }.onDisappear {
                self.viewModel.disposeObserver()
            }.environmentObject(
                DimensionScreen(width: geometry.size.width, height: geometry.size.height)
            ).alert(isPresented: self.$viewState.presentAlert, content: self.createAlert)
        }
    }

    private func createAlert() -> Alert {
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
    @ObservedObject var viewState: ContainerFormCulturalPracticeViewModelImpl.ViewState
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        ScrollView {
            VStack {
                ForEach(self.viewState.elementUIDataObservableList) { (elementUIData: ElementUIDataObservable) in
                    if elementUIData.type == InputElementObservable.TYPE_ELEMENT &&
                        self.canCastToInputElementObservable(elementUIData) {
                        TextFieldWithStyle(inputElement: elementUIData.toInputElementObservable()!).padding(.bottom, 35)
                    }

                    if elementUIData.type == SelectElementObservable.TYPE_ELEMENT &&
                        self.canCastToSelectElementObservable(elementUIData) {
                        PickerView(selectElementObservable: elementUIData.toSelectElementObservable()!).padding(.bottom, 35)
                    }
                }
            }
        }
    }

    func canCastToInputElementObservable(_ elementUIData: ElementUIDataObservable) -> Bool {
        elementUIData.toInputElementObservable() != nil
    }

    func canCastToSelectElementObservable(_ elementUIData: ElementUIDataObservable) -> Bool {
        elementUIData.toSelectElementObservable() != nil
    }
}

private struct PickerView: View {
    @ObservedObject var selectElementObservable: SelectElementObservable
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        VStack {
            Text(self.selectElementObservable.title)
                .font(.system(size: 15))
                .bold()
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)

            Picker(selection: self.$selectElementObservable.indexValue, label: Text("")) {
                ForEach((0..<self.selectElementObservable.values.count), id: \.self) { indexTupleValue in
                    Text(self.selectElementObservable.values[indexTupleValue].1)
                        .font(.system(size: 15))
                        .tag(indexTupleValue)
                }
            }.frame(
                width: self.dimensionScreen.width * 0.1,
                height: self.dimensionScreen.height * 0.1, alignment: .center
            ).pickerStyle(WheelPickerStyle())

        }
    }
}

private struct TextFieldWithStyle: View {
    @ObservedObject var inputElement: InputElementObservable
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        VStack {
            Text(self.inputElement.title)
                .font(.system(size: 15))
                .bold()
                .lineLimit(3)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
                .padding(.bottom, 5)

            TextField(self.inputElement.title, text: self.$inputElement.value)
                .keyboardType(.numbersAndPunctuation)
                .font(.system(size: 25))
                .padding(.horizontal, 10)
                .frame(
                    width: self.dimensionScreen.width * 0.3,
                    height: self.dimensionScreen.height * 0.1,
                    alignment: .center
            ).background(colorScheme == .dark ? Color.black : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 2)
                        .foregroundColor(self.getForegroundColorOfRoundedRectangle())
            )
        }
    }

    private func getForegroundColorOfRoundedRectangle() -> Color {
        self.inputElement.isValid ? .green : .red
    }
}

private struct ButtonValidate: View {
    var isButtonActivated: Bool
    var handleButton: () -> Void
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        Button(action: { self.handleButton() }) {
            Text("Valider")
                .frame(
                    minWidth: self.getWidthValidateButton(),
                    idealWidth: self.getWidthValidateButton(),
                    maxWidth: self.getWidthValidateButton(),
                    minHeight: self.getHeightValidateButton(),
                    idealHeight: self.getHeightValidateButton(),
                    maxHeight: self.getHeightValidateButton(),
                    alignment: .center
            )
        }.frame(
            width: self.getWidthValidateButton(),
            height: self.getHeightValidateButton(),
            alignment: .center
        ).foregroundColor(.white)
            .background(self.getBackgroundColor())
            .cornerRadius(10)
            .disabled(!self.isButtonActivated)
    }

    func getWidthValidateButton() -> CGFloat {
        dimensionScreen.width * 0.6
    }

    func getHeightValidateButton() -> CGFloat {
        dimensionScreen.height * 0.09
    }

    private func getBackgroundColor() -> Color {
        self.isButtonActivated ? Color(Util.getGreenColor()) : .red
    }
}
