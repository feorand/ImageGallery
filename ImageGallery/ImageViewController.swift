//
//  ImageViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 04.04.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 0.01
            scrollView.maximumZoomScale = 4
        }
    }
    
    var imageURL: URL? {
        didSet {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = self.imageURL, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    self.image = image
                }
            }
        }
    }
    
    var imageView = GalleryImageView()
    
    var image: UIImage? {
        didSet {
            if let image = image {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.scrollView.contentSize = image.size
                    self.scrollView.zoomScale = min(self.view.bounds.size.width / image.size.width, self.view.bounds.height / image.size.height)
                }
            }
        }
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
