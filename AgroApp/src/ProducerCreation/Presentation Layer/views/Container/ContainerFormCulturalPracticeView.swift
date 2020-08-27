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
                )

                Spacer()

                CenterView(
                    inputValues: self.$viewState.inputValues,
                    selecteValues: self.$viewState.selectValue,
                    inputElements: self.viewState.inputElements,
                    selectElements: self.viewState.selectElements,
                    isPrintMessageErrorInputValues: self.viewState.isPrintMessageErrorInputValues,
                    textErrorMessage: self.viewState.textErrorMessage
                )

                Spacer()

                ButtonValidate(
                    isButtonActivated: self.viewState.isFormValid,
                    handleButton: { self.viewModel.handleButtonValidate() }
                ).padding(.bottom, 10)

            }.onAppear {
                self.viewModel.configView()
                self.viewModel.subscribeToStateObserver()
                self.viewModel.subscribeToChangeInputValue()
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
    @Binding var selecteValues: [Int]
    var inputElements: [CulturalPracticeInputElement]
    var selectElements: [CulturalPracticeMultiSelectElement]
    @EnvironmentObject var dimensionScreen: DimensionScreen
    var isPrintMessageErrorInputValues: [Bool]
    var textErrorMessage: String

    var body: some View {
        ScrollView {
            VStack {
                InputElementListView(
                    inputElements: inputElements,
                    inputValues: $inputValues,
                    isPrintMessageErrorInputValues: isPrintMessageErrorInputValues,
                    textErrorMessage: textErrorMessage
                )

                PickerListView(selectElements: selectElements, selectValue: $selecteValues)
            }
        }
    }
}

private struct InputElementListView: View {
    @ObservedObject var inputElements: [InputElementObservable] = []
    var isPrintMessageErrorInputValues: [Bool]
    var textErrorMessage: String

    var body: some View {
        ForEach((0..<inputElements.count), id: \.self) { index in
            VStack {
                Text(self.inputElements[index].title)
                    .font(.system(size: 15))
                    .bold()
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)

                TextFieldWithStyle(
                    inputValue: self.$inputValues[index],
                    inputTitle:self.inputElements[index].valueEmpty.getUnitType()!.convertToString()
                )

                if self.isPrintMessageErrorInputValuesReady(
                    isPrintMessageErrorInputValues: self.isPrintMessageErrorInputValues,
                    index: index) {
                    Text(!self.isPrintMessageErrorInputValues[index] ? self.textErrorMessage : "")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .animation(.default)
                }
            }.padding(
                index == 0 ? .vertical : .bottom,
                30
            )
        }
    }

    func isPrintMessageErrorInputValuesReady(isPrintMessageErrorInputValues: [Bool], index: Int) -> Bool {
        isPrintMessageErrorInputValues.count > index
    }
}

private struct PickerListView: View {
    var selectElements: [SelectElement]
    @Binding var selectValue: [Int]
    @EnvironmentObject var dimensionScreen: DimensionScreen

    var body: some View {
        ForEach((0..<selectElements.count), id: \.self) { indexElement in
            VStack {
                Text(self.selectElements[indexElement].title)
                    .font(.system(size: 15))
                    .bold()
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)

                if self.isSelectValueIsReady(selectValue: self.selectValue, index: indexElement) {
                    Picker(selection: self.$selectValue[indexElement], label: Text("")) {
                        ForEach((0..<self.selectElements[indexElement].tupleCulturalTypeValue.count), id: \.self) { indexTupleValue in
                            Text(self.selectElements[indexElement].tupleCulturalTypeValue[indexTupleValue].1)
                                .font(.system(size: 15))
                                .tag(indexTupleValue)
                        }
                    }.frame(
                        width: self.dimensionScreen.width * 0.1,
                        height: self.dimensionScreen.height * 0.1, alignment: .center
                    ).pickerStyle(WheelPickerStyle())
                }
            }.padding(.bottom, 70)
        }
    }

    func isSelectValueIsReady(selectValue: [Int], index: Int) -> Bool {
        selectValue.count > index
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
        }
        .frame(
            width: self.getWidthValidateButton(),
            height: self.getHeightValidateButton(),
            alignment: .center
        )
            .foregroundColor(.white)
            .background(Color(Util.getGreenColor()))
            .cornerRadius(10)
            .disabled(!self.isButtonActivated)
    }

    func getWidthValidateButton() -> CGFloat {
        dimensionScreen.width * 0.6
    }

    func getHeightValidateButton() -> CGFloat {
        dimensionScreen.height * 0.09
    }
}
