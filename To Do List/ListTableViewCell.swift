//
//  ListTableViewCell.swift
//  To Do List
//
//  Created by Ben Tsai on 3/6/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
       func checkBoxToggle(sender: ListTableViewCell)
   }

class ListTableViewCell: UITableViewCell {
    weak var delegate: ListTableViewCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    var toDoItem: ToDoItem! {
        
        didSet { 
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}
