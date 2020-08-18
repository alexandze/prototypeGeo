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
                                if elementUIData.type == InputElementObservable.TYPE_ELEMENT {
                                    InputWithTitleElement(elementUIData: elementUIData) {}
                                        .padding(15)
                                }

                                if elementUIData.type == InputElementWithRemoveButtonObservable.TYPE_ELEMENT {
                                    InputWithTitleElement(elementUIData: elementUIData) {
                                        self.viewModel.handleRemoveNimButton(id: elementUIData.id)
                                    }.padding(15)
                                }
                            }
                        }

                        if self.viewState.addElementButton != nil {
                            ButtonAdd(
                                buttonElementObservable: self.viewState.addElementButton
                            ) {
                                self.viewModel.handleAddNimButton()
                            }.padding(.trailing, 2)
                                .offset(x:( geometryProxy.size.width / 2) - 67)
                        }

                        if self.keyboardFollower.isVisible {
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
                ).onAppear {
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
                        .padding(.bottom, 15)
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
                self.viewModel.handleValidateButton()
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
    var handleRemoveButton: () -> Void
    @Environment(\.colorScheme) var colorScheme

    init(elementUIData: ElementUIDataObservable, handleRemoveButton: @escaping () -> Void) {
        guard let inputElementData = elementUIData as? InputElementDataObservable else {
            self.inputElement = InputElementObservable.makeDefault()
            self.handleRemoveButton = handleRemoveButton
            return
        }
        self.handleRemoveButton = handleRemoveButton
        self.inputElement = inputElementData
    }

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Text("\(self.inputElement.title) \(self.getNumber())")
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
                        self.handleRemoveButton()
                    }
                }

                Spacer()
            }
        }
    }

    private func getNumber() -> String {
        let number = self.inputElement.number ?? 0
        return number > 0 ? String(number) : ""
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
    var buttonElement: ButtonElementObservable?
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme
    var action: () -> Void

    init(buttonElementObservable: ButtonElementObservable?, action: @escaping () -> Void) {
        self.buttonElement = buttonElementObservable
        self.action = action
    }

    var body: some View {
        Button(action: { self.action() }) {
            VStack(alignment: .center, spacing: 0) {
                Text("+")
                    .font(.system(size: 35))

                Text(self.getTitle())
                    .font(.system(size: 15))
                    .offset(y: -5)
            }.frame(width: 67 , height: 60)
        }
        .frame(
            width: 67,
            height: 60,
            alignment: .center
        ).foregroundColor(.white)
            .background(self.getbackgroundColor())
            .cornerRadius(38.5)
            .shadow(
                color: Color.black.opacity(0.3),
                radius: 3,
                x: 3,
                y: 3
        )
    }

    func getbackgroundColor() -> Color {
        let isEnabled = self.buttonElement?.isEnabled ?? false
        return isEnabled ? Color(Util.getGreenColor()) : .red
    }

    func getTitle() -> String {
        buttonElement?.title ?? ""
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
