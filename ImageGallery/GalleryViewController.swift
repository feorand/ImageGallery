//
//  ViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 29.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct ImageGalleryParameters {
    static let ImageWidth = 230
}

class GalleryViewController: UICollectionViewController
{
    var gallery = Gallery()
    var width = ImageGalleryParameters.ImageWidth
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery.imageDatas.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            //cell.imageView.image =
        }
        return cell
    }
    
    @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
        width = Int(CGFloat(ImageGalleryParameters.ImageWidth) * sender.scale)
        collectionView?.reloadData()
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = Int(CGFloat(width) * gallery.imageDatas[indexPath.item].ratio)
        return CGSize(width: width, height:height)
    }
}

extension GalleryViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let image = gallery.images[indexPath.item]
        let itemProvider = NSItemProvider(object: image)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = image
        session.localContext = collectionView
        return [dragItem]
    }
}

extension GalleryViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        let isLocal = session.localDragSession?.localContext as? UICollectionView == collectionView
        if isLocal {
            return session.canLoadObjects(ofClass: UIImage.self)
        } else {
            return session.canLoadObjects(ofClass: URL.self) &&
            session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isLocal = session.localDragSession?.localContext as? UICollectionView == collectionView
        return UICollectionViewDropProposal(operation: isLocal ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        for item in coordinator.items {
            if let sourcePath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    gallery.swap(index1: sourcePath.item, index2: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourcePath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
            } else {
                let placeholder = UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "PlaceholderCell")
                let context = coordinator.drop(item.dragItem, to: placeholder)
                
                var obtainedURL: URL?
                var obtainedRatio: CGFloat?
                
                let _ = item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { imageObject, error in
                    if let image = imageObject as? UIImage {
                        let ratio = image.size.height / image.size.width
                        obtainedRatio = ratio
                        if let url = obtainedURL {
                            self.insertImageData(url: url, ratio: ratio, indexPath: destinationIndexPath)
                        }
                    }
                }
                
                let _ = item.dragItem.itemProvider.loadObject(ofClass: URL.self) { urlObject, error in
                    if let url = urlObject {
                        //self.getActualImageFor(placeholderContext: context, url: url, ratio: aspectRatio)
                        obtainedURL = url
                        if let ratio = obtainedRatio {
                            self.insertImageData(url: url, ratio: ratio, indexPath: destinationIndexPath)
                        }
                    }
                }
            }
        }
    }
    
    private func insertImageData(url: URL, ratio: CGFloat, indexPath: IndexPath) {
        gallery.imageDatas.insert((url.imageURL, ratio), at: indexPath.item)
        
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [indexPath])
        }
    }
    
    private func getActualImageFor(placeholderContext: UICollectionViewDropPlaceholderContext, url: URL, ratio: CGFloat) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url.imageURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    placeholderContext.commitInsertion() { [weak self] _ in
                        self?.gallery.insert(image: image, withRatio: ratio)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    placeholderContext.deletePlaceholder()
                }
            }
        }
    }
}
