//
//  DimensionScreen.swift
//  AgroApp
//
//  Created by Alexandre Andze Kande on 2020-07-04.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import SwiftUI

class DimensionScreen: ObservableObject {
    @Published var width: CGFloat
    @Published var height: CGFloat

    init(width: CGFloat, height: CGFloat) {
        self.width = width
        self.height = height
    }
}
