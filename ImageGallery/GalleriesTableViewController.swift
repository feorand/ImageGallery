//
//  GalleriesTableViewController.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 30.03.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GalleriesTableViewController: UITableViewController
{
    var galleryList:GalleryList?
    private var galleries: [Gallery] {
        return galleryList?.galleries ?? []
    }
    private var nondeletedGalleries: [Gallery] {
        return galleries.filter{!$0.isDeleted}
    }
    private var deletedGalleries: [Gallery] {
        return galleries.filter{$0.isDeleted}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: startIndexPath, animated: false, scrollPosition: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Recently Deleted"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return nondeletedGalleries.count
        case 1:
            return deletedGalleries.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        var gallery: Gallery?
        
        switch indexPath.section {
        case 0:
            gallery = nondeletedGalleries[indexPath.row]
        case 1:
            gallery = deletedGalleries[indexPath.row]
        default:
            break
        }
        
        if let gallery = gallery {
            cell.textLabel?.text = gallery.name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("ShowGallery"):
            if let controller = segue.destination as? GalleryViewController, let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell) {
                controller.gallery = galleries[index.row]
            }
        default:
            print("Segue without identifier")
        }
    }
}
