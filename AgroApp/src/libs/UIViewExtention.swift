//
//  UIViewExtention.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-02.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

extension UIView {
    func isPortraitOrientationMobile() -> Bool {
        return traitCollection.horizontalSizeClass ==
            .compact && traitCollection.verticalSizeClass ==
            .regular
    }

    func isLandscapeOrientationMobile() -> Bool {
        return traitCollection.horizontalSizeClass ==
            .regular && traitCollection.verticalSizeClass ==
            .compact
    }
}
