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
    private var galleries: [Gallery] { return galleryList?.galleries ?? [] }
    private var nondeletedGalleries: [Gallery] { return galleries.filter{!$0.isDeleted} }
    private var deletedGalleries: [Gallery] { return galleries.filter{$0.isDeleted} }
    
    private func gallery(for indexPath:IndexPath) -> Gallery? {
        var gallery: Gallery?
        
        switch indexPath.section {
        case 0:
            gallery = nondeletedGalleries[indexPath.row]
        case 1:
            gallery = deletedGalleries[indexPath.row]
        default:
            break
        }
        
        return gallery
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startIndexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: startIndexPath, animated: false, scrollPosition: .none)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return deletedGalleries.count > 0 ? 2 : 1
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
        if let cell = cell as? GalleriesTableViewCell, let gallery = gallery(for: indexPath) {
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapGestureRecognized(_:)))
            doubleTapRecognizer.numberOfTapsRequired = 2
            cell.addGestureRecognizer(doubleTapRecognizer)
            cell.titleLabel?.text = gallery.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch indexPath.section {
            case 0:
                nondeletedGalleries[indexPath.row].isDeleted = true
                tableView.reloadData()
            case 1:
                let id = deletedGalleries[indexPath.row].id
                let index = galleryList?.galleries.index{$0.id == id}
                if let index = index {
                    galleryList?.galleries.remove(at: index)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 0:
            break
        case 1:
            let undeleteAction = UIContextualAction(style: .normal, title: "Undelete") { [weak self](contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
                self?.deletedGalleries[indexPath.row].isDeleted = false
                self?.tableView.reloadData()
                completionHandler(true)
            }
            undeleteAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            return UISwipeActionsConfiguration(actions: [undeleteAction])
        default:
            break
        }
        
        return nil
    }
    
    // MARK: - Gestures
    
    @objc func doubleTapGestureRecognized(_ recognizer: UITapGestureRecognizer) {
        if let cell = recognizer.view as? GalleriesTableViewCell {
            cell.doubleTapGestureRecognized()
        }
    }


    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "ShowGallery":
            if let sender = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: sender) {
                switch indexPath.section {
                case 0:
                    return true
                case 1:
                    return false
                default:
                    break
                }
            }
        default:
            print("Segue without identifier")
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case .some("ShowGallery"):
            if let navController = segue.destination as? UINavigationController, let controller = navController.viewControllers[0] as? GalleryViewController, let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                if let gallery = gallery(for: indexPath) {
                    view.endEditing(true)
                    controller.gallery = gallery
                }
            }
        default:
            print("Segue without identifier")
        }
    }
}
