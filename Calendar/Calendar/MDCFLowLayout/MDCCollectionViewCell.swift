//
//  MDCCollectionViewCell.swift
//  Calendar
//
//  Created by Shreesha on 17/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class MDCCollectionViewCell: UICollectionViewCell {

    static let kReuseIdentifier = "MDCCollectionViewCell"
    @IBOutlet weak var textLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5.0
    }
}
