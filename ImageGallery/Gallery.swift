//
//  Gallery.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 29.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class Gallery
{
    var name = "New Gallery"
    var imageDatas: [(url: URL, ratio: CGFloat)] = []
    
    private(set) var images: [UIImage] = []
    private(set) var aspectRatios: [CGFloat] = []
    
    func insert(image: UIImage, withRatio ratio: CGFloat) {
        images.insert(image, at: 0)
        aspectRatios.insert(ratio, at: 0)
    }
    
    func swap(index1: Int, index2: Int) {
        let image = images[index1]
        let ratio = aspectRatios[index1]
        images.remove(at: index1)
        aspectRatios.remove(at: index1)
        images.insert(image, at: index2)
        aspectRatios.insert(ratio, at: index2)
    }
}
