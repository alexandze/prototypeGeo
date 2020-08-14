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
                        ForEach(self.viewState.utilElementUIDataSwiftUIList) { (util: UtilElementUIDataSwiftUI) in
                            VStack {
                                if util.elementUIData.type == InputElement.TYPE_ELEMENT {
                                    InputWithTitleElement(util: util).padding(15)
                                }

                                if util.elementUIData.type == ButtonElement.TYPE {
                                    HStack {
                                        ButtonAdd(util: util) { print("Add")}
                                        Spacer()
                                    }.padding(.leading, 15)
                                        .padding(.top, -20)
                                }
                            }
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

                ButtonValidate(
                    title: "Valider",
                    isButtonActivated: true,
                    action: {
                        self.viewModel.handleButtonValidate()
                    }
                ).padding(.bottom, 20)

            }.environmentObject(self.viewModel.viewState)
            .environmentObject(self.keyboardFollower)
            .environmentObject(
                DimensionScreen(width: geometryProxy.size.width, height: geometryProxy.size.height)
            )

        }
    }

    private func getValueBinding(_ index: Int) -> Binding<String> {
        $viewState.utilElementUIDataSwiftUIList[index].valueState
    }

    private func getIsValid(_ index: Int) -> Bool {
        (viewState.utilElementUIDataSwiftUIList[index].elementUIData as? InputElement)?.isValid ?? false
    }

    private func getTitle(_ index: Int) -> String {
        viewState.utilElementUIDataSwiftUIList[index].elementUIData.title
    }

    private func getIsRequired(_ index: Int) -> Bool {
        (viewState.utilElementUIDataSwiftUIList[index].elementUIData as? InputElementData)?.isRequired ?? true
    }

    private func getKeyboardType(_ index: Int) -> KeyboardType {
        (viewState.utilElementUIDataSwiftUIList[index].elementUIData as? InputElementData)?.keyboardType ?? .normal
    }

    private func isButtonAddElement(_ index: Int) -> Bool {
        guard let buttonAdd = viewState.utilElementUIDataSwiftUIList[index].elementUIData as? ButtonElement,
            buttonAdd.action == ElementFormAction.add.rawValue else {
            return false
        }

        return true
    }

    private func isInputElement(_ index: Int) -> Bool {
        viewState.utilElementUIDataSwiftUIList[index].elementUIData.type == InputElement.TYPE_ELEMENT
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

private struct InputWithTitleRemoveButton: View {
    var uuidUtilElementUIData: UUID
    var title: String
    var isValid: Bool
    var value: Published<String>.Publisher
    @State var myValue = ""

    var handleRemoveButton: (UUID) -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                Spacer()
            }

            HStack {
                ZStack {
                    TextField(
                        "",
                        text: self.$myValue
                        )
                        .padding(
                        EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
                    ).background(colorScheme == .dark ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                                .foregroundColor(isValid ? .green : .red)
                    )

                    HStack {
                        Spacer()

                        if isValid {
                            getValidImage()
                        } else {
                            getNoValidImage()
                        }
                    }
                }

                getRemoveImage()
                    .onTapGesture {
                        self.handleRemoveButton(self.uuidUtilElementUIData)
                }
            }
        }
    }
}

private struct InputWithTitleElement: View {
    @ObservedObject var util: UtilElementUIDataSwiftUI
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Text(self.util.elementUIData.title)
                Spacer()
            }

            HStack {
                ZStack {
                    TextField(
                        "",
                        text: $util.valueState
                    ).keyboardType(self.getKeyboardType())
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

                        if self.getIsValid() {
                            getValidImage()
                        }

                        if !self.getIsValid() && self.getIsRequired() {
                            getNoValidImage()
                        }

                        if !self.getIsValid() && !self.getIsRequired() {
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

    private func getKeyboardType() -> UIKeyboardType {
        (util.elementUIData as? InputElementData)?.keyboardType.getUIKeyboardType() ?? .default
    }

    private func getIsValid() -> Bool {
        (util.elementUIData as? InputElementData)?.isValid ?? false
    }

    private func getIsRequired() -> Bool {
        (util.elementUIData as? InputElementData)?.isRequired ?? true
    }

    private func getForegroundColorOfRoundedRectangle() -> Color {
        self.getIsRequired()
            ? self.getIsValid() ? .green : .red
            : self.getIsValid() ? .green : .yellow
    }

    private func isInputElementWithRemoveButton() -> Bool {
        (util.elementUIData as? InputElementWithRemoveButton) != nil
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
        }.frame(
            width: dimensionScreen.width * 0.6,
            height: dimensionScreen.height * 0.09
        ).foregroundColor(.white)
            .background(Color(Util.getGreenColor()))
            .cornerRadius(10)
    }
}

private struct ButtonAdd: View {
    @ObservedObject var util: UtilElementUIDataSwiftUI
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme
    var action: () -> Void

    var body: some View {
        Button(action: { self.action() }) {
            Text(util.elementUIData.title)
                .frame(
                    width: dimensionScreen.width * 0.2,
                    height: dimensionScreen.height * 0.06,
                    alignment: .center
            ).font(.system(size: 45))
        }.frame(
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
