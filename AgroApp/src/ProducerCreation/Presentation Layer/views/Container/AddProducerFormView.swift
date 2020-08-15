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
    @ObservedObject var keyboardFollower: KeyboardFollower
    @ObservedObject var viewState: AddProducerFormViewModelImpl.ViewState

    @State var value: String = ""

    init(
        addProducerFormViewModel: AddProducerFormViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = addProducerFormViewModel
        self.keyboardFollower = keyboardFollower
        self.viewState = addProducerFormViewModel.viewState
    }

    var body: some View {

        GeometryReader { (geometryProxy: GeometryProxy) in
            VStack {
                ScrollView {
                    VStack {
                        ForEach(self.viewState.elementUIDataObservableList) { (elementUIData: ElementUIDataObservable) in
                            VStack {
                                if (elementUIData.type == InputElementObservable.TYPE_ELEMENT) {
                                    InputWithTitleElement(elementUIData: elementUIData)
                                        .padding(15)
                                }

                                if elementUIData.type == ButtonElementObservable.TYPE_ELEMENT {
                                    HStack {
                                        ButtonAdd(elementUIData: elementUIData) { print("Add")}
                                        Spacer()
                                    }.padding(.leading, 15)
                                        .padding(.top, -20)
                                }

                            }
                        }

                        if self.isKeyboardVisible() {
                            self.getButtonValidate()
                                .padding(.vertical, 15)
                        }
                    }
                }.frame(
                    width: geometryProxy.size.width,
                    height: self.isKeyboardVisible()
                        ? self.calculHeightWithKeyBoard(geometryProxy: geometryProxy)
                        : self.calculHeightWithoutKeyBoard(geometryProxy: geometryProxy),
                    alignment: .top
                )//.offset(y: self.isKeyboardVisible() ? -self.keyboardFollower.keyboardHeight + self.getOffset(geometryProxy: geometryProxy) : 0)
                    .onAppear {
                        self.viewModel.configView()
                        self.viewModel.subscribeToStateObservable()
                }
                .onDisappear {
                    self.viewModel.dispose()
                }
                .animation(.default)

                Spacer()

                if !self.isKeyboardVisible() {
                    self.getButtonValidate()
                        .padding(.bottom, 20)
                }
            }.environmentObject(self.viewModel.viewState)
                .environmentObject(self.keyboardFollower)
                .environmentObject(
                    DimensionScreen(width: geometryProxy.size.width, height: geometryProxy.size.height)
            )

        }
    }

    private func getButtonValidate() -> some View {
        ButtonValidate(
            title: "Valider",
            isButtonActivated: self.viewState.isAllInputValid,
            action: {
                self.viewModel.handleButtonValidate()
        }
        )
    }

    private func isKeyboardVisible() -> Bool {
        keyboardFollower.isVisible
    }

    private func calculHeightWithKeyBoard(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height - keyboardFollower.keyboardHeight
    }

    private func getOffset(geometryProxy: GeometryProxy) -> CGFloat {
        let heightCenter = geometryProxy.size.height - keyboardFollower.keyboardHeight
        let offset = (geometryProxy.size.height - heightCenter) / 2
        return offset
    }

    private func calculHeightWithoutKeyBoard(geometryProxy: GeometryProxy) -> CGFloat {
        geometryProxy.size.height * 0.85
    }
}

private struct InputWithTitleElement: View {
    @ObservedObject var inputElement: InputElementDataObservable
    @Environment(\.colorScheme) var colorScheme

    init(elementUIData: ElementUIDataObservable) {
        guard let inputElementData = elementUIData as? InputElementObservable else {
            self.inputElement = InputElementObservable.makeDefault()
            return
        }

        self.inputElement = inputElementData
    }

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Text(self.inputElement.title)
                Spacer()
            }

            HStack {
                ZStack {
                    TextField(
                        "",
                        text: $inputElement.value
                    ).keyboardType(self.inputElement.keyboardType.getUIKeyboardType())
                        .padding(
                            EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
                    ).background(colorScheme == .dark ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                                .foregroundColor(self.getForegroundColorOfRoundedRectangle())
                    )

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

                if self.isInputElementWithRemoveButton() {
                    getRemoveImage().onTapGesture {
                        print("remove")
                    }
                }

                Spacer()
            }
        }
    }

    private func getForegroundColorOfRoundedRectangle() -> Color {
        self.inputElement.isRequired
            ? self.inputElement.isValid ? .green : .red
            : self.inputElement.isValid ? .green : .yellow
    }

    private func isInputElementWithRemoveButton() -> Bool {
        (self.inputElement as? InputElementWithRemoveButtonObservable) != nil
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

private struct ButtonAdd: View {
    @ObservedObject var buttonElement: ButtonElementObservable
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme
    var action: () -> Void

    init(elementUIData: ElementUIDataObservable, action: @escaping () -> Void) {
        guard let buttonElement = elementUIData as? ButtonElementObservable else {
            self.buttonElement = ButtonElementObservable.makeDefault()
            self.action = action
            return
        }

        self.buttonElement = buttonElement
        self.action = action
    }

    var body: some View {
        Button(action: { self.action() }) {
            Text(buttonElement.title)
                .frame(
                    width: dimensionScreen.width * 0.2,
                    height: dimensionScreen.height * 0.06,
                    alignment: .center
            ).font(.system(size: 45))
        }
        .frame(
            width: dimensionScreen.width * 0.2,
            height: dimensionScreen.height * 0.06,
            alignment: .center
        ).foregroundColor(.white)
            .background(Color(Util.getGreenColor()))
            .cornerRadius(10)
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
