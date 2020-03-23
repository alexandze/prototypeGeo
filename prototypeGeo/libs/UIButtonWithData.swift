//
//  UIButtonWithData.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-23.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

class UIButtonWithData<T>: UIButton {
    var data: T?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
