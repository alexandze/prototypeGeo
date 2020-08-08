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
    let keyboardFollower: KeyboardFollower
    @State var name: String = ""
    @State var isPaddingBottom: Bool = false
    @State var currentIndexEditing: Int = -1
    @State var maxYCurrentTextFieldEditing: CGFloat = -1

    init(
        addProducerFormViewModel: AddProducerFormViewModel,
        keyboardFollower: KeyboardFollower
    ) {
        self.viewModel = addProducerFormViewModel
        self.keyboardFollower = keyboardFollower
    }

    var body: some View {
        GeometryReader { (_: GeometryProxy) in
            ScrollView {
                VStack(alignment: .center, spacing: 30) {
                    Text("current index \(self.currentIndexEditing) \(self.maxYCurrentTextFieldEditing)")
                    ForEach(0...5, id: \.self) { index in

                        VStack(alignment: .center) {

                            InputWithTitleElement(
                                title: "Nom",
                                isValid: true,
                                index: index,
                                currentIndexEditing: self.$currentIndexEditing,
                                maxYCurrentTextFieldEditing: self.$maxYCurrentTextFieldEditing,
                                value: self.$name
                            )
                        }.padding(.bottom, self.currentIndexEditing == index ? 50: 20)
                    }

                    Button(action: {self.isPaddingBottom = !self.isPaddingBottom}) {
                        Text("okm")
                    }
                }
            }
        }
        .onAppear {
            self.viewModel.configView()
            self.viewModel.subscribeToStateObservable()
        }
        .onDisappear {
            self.viewModel.dispose()
        }
        .animation(.default)
    }
}

private struct InputWithTitleElement: View {
    var title: String
    var isValid: Bool
    var index: Int
    @Binding var currentIndexEditing: Int
    @Binding var maxYCurrentTextFieldEditing: CGFloat
    @Binding var value: String

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack {
                Text(self.title)
                Spacer()
            }

            HStack {
                ZStack {
                    GeometryReader { (geometry: GeometryProxy)  in
                        TextField(
                            "\(geometry.frame(in: .global).origin.y)",
                            text: self.$value,
                            onEditingChanged: { isEditing in self.onEditingTextField(isEditing: isEditing, maxYCurrentTextField: geometry.frame(in: .global).maxY) },
                            onCommit: self.onCommitTextField
                        )

                            .padding(
                                EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 50)
                        ).background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lineWidth: 2)
                                    // TODO Changer la couleur en fonction une image en fonction de la validite
                                    .foregroundColor(self.isValid ? .green : .red)
                            )
                        HStack {
                            Spacer()
                            // TODO Aficher une image en fonction de la validite
                            if self.isValid {
                                self.getImageValid()
                            } else {
                                self.getImageNoValid()
                            }
                        }
                    }
                }
                Spacer()
            }

        }.padding(.leading, 10)
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

    private func onEditingTextField(isEditing: Bool, maxYCurrentTextField: CGFloat) {
        if isEditing {
            currentIndexEditing = index
            self.maxYCurrentTextFieldEditing = maxYCurrentTextField
            return
        }

        currentIndexEditing = -1
    }

    private func onCommitTextField() {
        currentIndexEditing = -1
        self.maxYCurrentTextFieldEditing = -1
    }
}
