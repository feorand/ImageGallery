//
//  GalleryImageView.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 05.04.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GalleryImageView: UIView
{
    var image: UIImage? {
        didSet {
            frame = CGRect(origin: CGPoint.zero, size: image?.size ?? CGSize.zero)
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let image = image {
            image.draw(in: rect)
        }
    }
}
