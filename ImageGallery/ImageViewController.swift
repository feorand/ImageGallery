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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.addSubview(imageView)
            scrollView.minimumZoomScale = 0.01
            scrollView.maximumZoomScale = 4
        }
    }
    
    @IBOutlet weak var scrollViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewHeightConstraint: NSLayoutConstraint!
    
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
                    self.activityIndicator.isHidden = true
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
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewWidthConstraint.constant = scrollView.contentSize.width
        scrollViewHeightConstraint.constant = scrollView.contentSize.height
    }
}
