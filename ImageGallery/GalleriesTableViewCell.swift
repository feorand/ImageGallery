//
//  GalleriesTableViewCell.swift
//  ImageGallery
//
//  Created by Pavel Prokofyev on 04.04.2018.
//  Copyright © 2018 Pavel Prokofyev. All rights reserved.
//

import UIKit

class GalleriesTableViewCell: UITableViewCell
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func doubleTapGestureRecognized() {
        titleTextField.delegate = self
        titleTextField.text = titleLabel.text
        titleTextField.isHidden = false
        titleLabel.isHidden = true
        titleTextField.becomeFirstResponder()
    }
}

extension GalleriesTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleLabel.text = textField.text
        titleLabel.isHidden = false
        textField.isHidden = true
        textField.resignFirstResponder()
        return true
    }
}
