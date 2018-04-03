//
//  GallerySplitViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 03.04.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GallerySplitViewController: UISplitViewController
{
    var galleryList = GalleryList()

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        preferredPrimaryColumnWidthFraction = 0.2
        
        galleryList.galleries = [
            Gallery(name: "First Gallery"),
            Gallery(name: "Second Gallery"),
            Gallery(name: "Third Gallery")
        ]
        
        if let navController = childViewControllers[0] as? UINavigationController, let controller = navController.viewControllers[0] as? GalleriesTableViewController {
            controller.galleryList = galleryList
        }
        
        if let navController = childViewControllers[1] as? UINavigationController, let controller = navController.viewControllers[0] as? GalleryViewController {
            controller.gallery = galleryList.galleries[0]
        }
    }
}
