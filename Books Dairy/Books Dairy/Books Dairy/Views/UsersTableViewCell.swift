//
//  USersTableViewCell.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

protocol UsersTableViewCellDelegate : class {
    func usersTableViewCellDidSelectEditButtunAtIndex(index :Int)
}

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel : UILabel!
    @IBOutlet weak var editButton : UIButton!


    weak var delegate : UsersTableViewCellDelegate?
    var index = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editButtonDidClick(sender : UIButton) {
        delegate?.usersTableViewCellDidSelectEditButtunAtIndex(index)
    }
}
