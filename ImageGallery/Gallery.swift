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
    var name: String
    var imageDatas: [(url: URL, ratio: CGFloat)] = []
    var isDeleted = false 
    
    init(name: String = "New Gallery") {
        self.name = name
    }
}
