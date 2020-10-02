//
//  ProfilView.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-09-27.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI

struct ProfilView: View {
    let viewModel: ProfilViewModel
    @ObservedObject var keyboardFollower: KeyboardFollower
    @ObservedObject var viewState: ProfilViewModelImpl.ViewState
    
    init(
        viewModel: ProfilViewModel,
        keyboardFollower: KeyboardFollower = KeyboardFollower(),
        viewState: ProfilViewModelImpl.ViewState
    ) {
        self.viewModel = viewModel
        self.keyboardFollower = keyboardFollower
        self.viewState = viewState
    }
    
    var body: some View {
        GeometryReader { (geometryProxy: GeometryProxy) in
            ScrollView {
                VStack {
                    ImageProfil(
                        width: geometryProxy.size.width * 0.4,
                        height: geometryProxy.size.height * 0.2
                    ).padding()
                    
                    NameView(
                        firstName: "Aurelie",
                        lastName: "Dumond",
                        email: "aurelie_dumond@gmail.com"
                    ).padding()
                    
                    HStack {
                        CardSats(number: "5", title: "Producteurs")
                        CardSats(number: "25", title: "Parcelles")
                        CardSats(number: "10", title: "Scénarios")
                    }
                }
            }.environmentObject(
                DimensionScreen(width: geometryProxy.size.width, height: geometryProxy.size.height))
        }.onAppear {
            self.viewModel.handleOnAppear()
        }
        .onDisappear {
            self.viewModel.handleOnDisappear()
        }
        
    }
}

struct NameView: View {
    var firstName: String
    var lastName: String
    var email: String
    
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: dimensionScreen.width * 0.8, height: dimensionScreen.height * 0.2)
                .cornerRadius(12)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .shadow(color: .gray, radius: 5)
            
            VStack(alignment: .center, spacing: 5) {
                Text(firstName)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(width: dimensionScreen.width * 0.75)
                HrLineView()
                
                Text(lastName)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(width: dimensionScreen.width * 0.75)
                
                HrLineView()
                
                Text(email)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(width: dimensionScreen.width * 0.75)
                
            }
        }
    }
}

struct CardSats: View {
    var number: String
    var title: String
    
    @EnvironmentObject var dimensionScreen: DimensionScreen
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: dimensionScreen.width * 0.25, height: dimensionScreen.height * 0.1)
                .cornerRadius(12)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .shadow(color: .gray, radius: 5)
            
            VStack {
                Text(self.number)
                Text(self.title)
            }
        }
    }
}

struct ImageProfil: View {
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        self.getImageProfil(width, height)
    }
    
    private func getImageProfil(_ width: CGFloat, _ height: CGFloat, _ image: UIImage? = nil) -> some View {
        guard let uiImage = image else {
            return Image("profile_image")
                .resizable()
                .frame(width: width, height: height)
                .cornerRadius(height / 2, antialiased: true)
                .shadow(color: .gray, radius: 5)
        }
        
        return Image(uiImage: uiImage)
            .resizable()
            .frame(width: width, height: height)
            .cornerRadius(height / 2, antialiased: true)
            .shadow(color: .gray, radius: 5)
    }
}

struct HrLineView: View {
    @EnvironmentObject var dimensionScreen: DimensionScreen
    
    var body: some View {
        Rectangle()
            .frame(width: dimensionScreen.width * 0.7, height: 0.5)
            .foregroundColor(.gray)
    }
    
}
