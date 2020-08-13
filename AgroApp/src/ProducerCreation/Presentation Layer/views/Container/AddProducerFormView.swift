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
                        ForEach(self.viewState.utilElementUIDataSwiftUIList.indices, id: \.self) { (index: Int) in
                            VStack {
                                if self.isInputElement(index) {
                                    InputWithTitleElement(
                                        title: self.getTitle(index),
                                        isValid: self.getIsValid(index),
                                        value: self.getValueBinding(index)
                                    ).padding(15)
                                }
                                
                                if self.isButtonAddElement(index) {
                                    HStack {
                                        ButtonAdd(
                                            title: self.getTitle(index),
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
                    action: {
                        self.viewModel.handleButtonValidate()

                }
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
    
    private func getValueBinding(_ index: Int) -> Binding<String> {
        $viewState.utilElementUIDataSwiftUIList[index].valueState
    }
    
    private func getIsValid(_ index: Int) -> Bool {
        (viewState.utilElementUIDataSwiftUIList[index].elementUIData as? InputElement)?.isValid ?? false
    }
    
    private func getTitle(_ index: Int) -> String {
        viewState.utilElementUIDataSwiftUIList[index].elementUIData.title
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
        geometryProxy.size.height
    }
}

private struct InputWithTitleRemoveButton: View {
    var uuidUtilElementUIData: UUID
    var title: String
    var isValid: Bool
    @Binding var value: String
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
                        text: self.$value
                    ).padding(
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
                            getImageYesValid()
                        } else {
                            getImageNoValid()
                        }
                    }
                }
                
                getImageRemove()
                    .onTapGesture {
                        self.handleRemoveButton(self.uuidUtilElementUIData)
                }
            }
        }
    }
}

private struct InputWithTitleElement: View {
    var title: String
    var isValid: Bool
    @Binding var value: String
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
                    ).padding(
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
                            getImageYesValid()
                        } else {
                            getImageNoValid()
                        }
                    }
                }
                
                Spacer()
            }
        }
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
        ).foregroundColor(.white)
            .background(Color(Util.getGreenColor()))
            .cornerRadius(10)
    }
}

private func getImageYesValid() -> some View {
    Image("yes48")
        .resizable()
        .frame(width: 35, height: 35)
}

private func getImageNoValid() -> some View {
    Image("no48")
        .resizable()
        .frame(width: 35, height: 35)
}

private func getImageRemove() -> some View {
    Image("stop")
        .resizable()
        .frame(width: 35, height: 35)
}
