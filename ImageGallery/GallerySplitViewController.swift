//
//  GallerySplitViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 03.04.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GallerySplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        preferredPrimaryColumnWidthFraction = 0.2
    }
}
