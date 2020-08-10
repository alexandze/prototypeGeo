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
                        ForEach(0..<self.viewState.listElementUIData.count, id: \.self) { index in
                            VStack {
                                if self.isInputElement(index: index) &&
                                    self.hasIsValid(index: index) &&
                                    self.hasValue(index: index) {

                                    InputWithTitleElement(
                                        title: self.viewState.listElementUIData[index].title,
                                        isValid: self.viewState.listElementValid[index],
                                        value: self.$viewState.listElementValue[index]
                                    ).padding(15)
                                }

                                if self.isButtonElement(index: index) {
                                    HStack {
                                        ButtonAdd(
                                            title: self.viewState.listElementUIData[index].title,
                                            action: {}
                                        )

                                        Spacer()
                                    }.padding(.leading, 15)
                                        .padding(.top, -20)
                                }
                            }
                        }

                    }.padding(.bottom, 50)
                }

                Spacer()

                ButtonValidate(
                    title: "Valider",
                    isButtonActivated: true,
                    action: {}
                ).padding(10)

            }.frame(
                width: geometryProxy.size.width,
                height: self.isKeyboardVisible()
                    ? self.calculHeightWithKeyBoard(geometryProxy: geometryProxy)
                    : self.calculHeightWithoutKeyBoard(geometryProxy: geometryProxy),
                alignment: .top
            ).offset(y: self.isKeyboardVisible()
                ? -self.keyboardFollower.keyboardHeight + self.getOffset(geometryProxy: geometryProxy)
                : 0
            ).onAppear {
                self.viewModel.configView()
                self.viewModel.subscribeToStateObservable()
            }
            .onDisappear {
                self.viewModel.dispose()
            }
            .animation(.default)
            .environmentObject(self.viewModel.viewState)
            .environmentObject(self.keyboardFollower)
            .environmentObject(
                DimensionScreen(width: geometryProxy.size.width, height: geometryProxy.size.height)
            )

        }
    }

    private func isButtonElement(index: Int) -> Bool {
        viewState.listElementUIData[index].type == ButtonElement.TYPE
    }

    private func isInputElement(index: Int) -> Bool {
        viewState.listElementUIData[index].type == InputElement.TYPE
    }

    private func hasIsValid(index: Int) -> Bool {
        Util.hasIndexInArray(viewState.listElementValid, index: index)
    }

    private func hasValue(index: Int) -> Bool {
        Util.hasIndexInArray(viewState.listElementValue, index: index)
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
        geometryProxy.size.height
    }
}

private struct InputWithTitleElement: View {
    var title: String
    var isValid: Bool
    @Binding var value: String
    @EnvironmentObject var viewState: AddProducerFormViewModelImpl.ViewState
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            HStack {
                Text(self.title)
                Spacer()
            }

            HStack {
                ZStack {
                    TextField(
                        "",
                        text: self.$value
                    )
                        .padding(
                            EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
                    ).background(colorScheme == .dark ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 2)
                                .foregroundColor(self.isValid ? .green : .red)
                    )
                    HStack {
                        Spacer()

                        if self.isValid {
                            self.getImageValid()
                        } else {
                            self.getImageNoValid()
                        }
                    }
                }

                Spacer()
            }
        }
    }

    private func getImageValid() -> some View {
        Image("yes48")
            .resizable()
            .frame(width: 35, height: 35)
    }

    private func getImageNoValid() -> some View {
        Image("no48")
            .resizable()
            .frame(width: 35, height: 35)
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
    var title: String
    var action: () -> Void
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: { self.action() }) {
            Text("+")
                .frame(
                    width: dimensionScreen.width * 0.2,
                    height: dimensionScreen.height * 0.06,
                    alignment: .center
                ).font(.system(size: 45))
        }.frame(
            width: dimensionScreen.width * 0.2,
            height: dimensionScreen.height * 0.06,
            alignment: .center
        ).foregroundColor(colorScheme == .dark ? .white : .black)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(10)
    }
}
