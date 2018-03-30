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
    var galleries = GalleriesList().galleries
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return galleries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryCell", for: indexPath)
        let gallery = galleries[indexPath.row]
        cell.textLabel?.text = gallery.name
        return cell
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
