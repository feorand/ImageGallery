//
//  Gallery.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 29.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class Gallery {
    var images: [UIImage] = []
    var aspectRatios: [CGFloat] = []
    
    func insert(image: UIImage, withRatio ratio: CGFloat) {
        images.insert(image, at: 0)
        aspectRatios.insert(ratio, at: 0)
    }    
}
