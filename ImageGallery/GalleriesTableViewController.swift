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
    private var galleries: [Gallery]? {
        return galleryList?.galleries
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: startIndexPath, animated: false, scrollPosition: .none)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleries?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        if let gallery = galleries?[indexPath.row] {
            cell.textLabel?.text = gallery.name
        }
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("ShowGallery"):
            if let controller = segue.destination as? GalleryViewController, let cell = sender as? UITableViewCell, let index = tableView.indexPath(for: cell), let gallery = galleries?[index.row] {
                controller.gallery = gallery
            }
        default:
            print("Segue without identifier")
        }
    }
}
