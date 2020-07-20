//
//  FieldSelectedViewCell.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-03-05.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import UIKit

public class FieldSelectedViewCell {
    let contentView: UIView

    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(contentView: UIView) {
        self.contentView = contentView
    }
}
