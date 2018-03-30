//
//  Array+Extension.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 30.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

extension Array {
    mutating func move(from sourceIndex: Int, to destinationIndex: Int) {
        let element = self[sourceIndex]
        self.remove(at: sourceIndex)
        self.insert(element, at: destinationIndex)
    }
}
