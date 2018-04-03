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
    private static var nextID = 0
    
    private class func GenerateID() -> Int {
        let id = nextID
        nextID += 1
        return id
    }
    
    var id: Int
    var name: String
    var imageDatas: [(url: URL, ratio: CGFloat)] = []
    var isDeleted = false
    
    init(name: String = "New Gallery") {
        self.name = name
        id = Gallery.GenerateID()
    }
    
}
