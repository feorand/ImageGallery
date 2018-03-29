//
//  ViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 29.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GalleryViewController: UICollectionViewController
{
    var gallery = Gallery()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dropDelegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageView.image = gallery.images[indexPath.item]
        }
        return cell
    }
}

extension GalleryViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: URL.self) &&
            session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isLocal = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isLocal ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        for item in coordinator.session.items {
            let indexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
            let placeholder = UICollectionViewDropPlaceholder(insertionIndexPath: indexPath, reuseIdentifier: "PlaceholderCell")
            let context = coordinator.drop(item, to: placeholder)
            
            let _ = item.itemProvider.loadObject(ofClass: URL.self) { url, error in
            //item.itemProvider.loadItem(forTypeIdentifier: "URL", options: nil) { url, error in
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url!.imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        context.commitInsertion() { [weak self] _ in
                            self?.gallery.images += [image]
                        }
                    } else {
                        context.deletePlaceholder()
                    }
                }
                task.resume()
            }
        }
    }
}
