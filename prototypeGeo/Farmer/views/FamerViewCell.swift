//
//  FamerViewCell.swift
//  prototypeGeo
//
//  Created by Alexandre Andze Kande on 2020-01-03.
//  Copyright © 2020 Alexandre Andze Kande. All rights reserved.
//

import Foundation
import UIKit

public class FarmerViewCell {
    let contentView: UIView
    
    init(contentView: UIView) {
        self.contentView = contentView
    }
    
    func initView(textLabel: String, nameImage: String) {
        let imageView = createImageView(nameImage: nameImage, tag: 2)
        addImageViewToContentView(contentView: self.contentView, imageView: imageView)
        positionImage(contentView: self.contentView, imageView: imageView)
        let label = createLabel(text: textLabel, tag: 1)
        addLabelToContentView(contentView: self.contentView, label: label)
        positionLabel(contentView: self.contentView, label: label, ImageView: imageView)
    }
    
    
    private func createLabel(text: String, tag: Int) -> UILabel {
        let label = UILabel()
        label.text = text
        label.tag = tag
        
        label.textColor = UIColor {traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            case .light:
                return .black
            default:
                return .white
            }
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }
    
    private func createImageView(nameImage: String, tag: Int) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: nameImage)?.withTintColor(Util.getOppositeColorBlackOrWhite())
        let imageResized = image?.resizeImage(targetSize: CGSize(width: 40, height: 40))
        imageView.image = imageResized
        return imageView
    }
    
    private func positionImage(contentView: UIView, imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            // imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func positionLabel(contentView: UIView, label: UIView, ImageView: UIImageView) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: ImageView.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func addLabelToContentView(contentView: UIView, label: UILabel) {
        contentView.addSubview(label)
    }
    
    private func addImageViewToContentView(contentView: UIView, imageView: UIImageView) {
        contentView.addSubview(imageView)
    }
}
