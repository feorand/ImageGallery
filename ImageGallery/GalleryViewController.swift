//
//  ViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 29.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

struct ImageGalleryParameters {
    static let ImageWidth: CGFloat = 190.0
    static let MinimumInterImageWidth: CGFloat = 15.0
}

class GalleryViewController: UICollectionViewController
{
    var gallery: Gallery?
    var width = ImageGalleryParameters.ImageWidth
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = gallery?.name
        collectionView?.dragDelegate = self
        collectionView?.dropDelegate = self        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery?.imageDatas.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        if let cell = cell as? ImageCollectionViewCell {
            cell.imageView.image = nil
            DispatchQueue.global(qos: .userInitiated).async {
                if let gallery = self.gallery, let data = try? Data(contentsOf: gallery.imageDatas[indexPath.item].url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.imageView.image = UIImage(contentsOfFile: "no_image")
                    }
                }
            }
        }
        return cell
    }
    
    @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
        width *= sender.scale
        sender.scale = 1.0
        flowLayout?.invalidateLayout()
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        view.endEditing(true)
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let gallery = gallery {
            let height = CGFloat(width) * gallery.imageDatas[indexPath.item].ratio
            return CGSize(width: width, height:height)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ImageGalleryParameters.MinimumInterImageWidth
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ImageGalleryParameters.MinimumInterImageWidth
    }
}

extension GalleryViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let object = String(indexPath.item) as NSString
        let itemProvider = NSItemProvider(object: object)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = object
        session.localContext = collectionView
        return [dragItem]
    }
}

extension GalleryViewController: UICollectionViewDropDelegate
{
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if isLocal(session) {
            return session.canLoadObjects(ofClass: NSString.self)
        } else {
            return session.canLoadObjects(ofClass: URL.self) &&
            session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: isLocal(session) ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        for item in coordinator.items {
            if let sourcePath = item.sourceIndexPath {
                collectionView.performBatchUpdates({
                    gallery?.imageDatas.move(from: sourcePath.item, to: destinationIndexPath.item)
                    collectionView.deleteItems(at: [sourcePath])
                    collectionView.insertItems(at: [destinationIndexPath])
                })
            } else {                
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
        gallery?.imageDatas.insert((url.imageURL, ratio), at: indexPath.item)
        
        DispatchQueue.main.async {
            self.collectionView?.insertItems(at: [indexPath])
        }
    }
    
    private func isLocal(_ session: UIDropSession) -> Bool {
        return session.localDragSession?.localContext as? UICollectionView == collectionView
    }
}
