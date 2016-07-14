//
//  ProfileHeaderView.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum SelectedSegement {
    case Read
    case Wish
    case AllBooks
}

protocol ProfileHeaderViewDelegate: class {
    func profileHeaderViewDidClickSegmentAt(segment : SelectedSegement)
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var allBooksSegmentButton: UIButton!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readSegmentButton: UIButton!
    @IBOutlet weak var wishSegmentButton: UIButton!
    var selectedSegment : SelectedSegement = .AllBooks {
        didSet {
            changeTheSelectionState()
        }
    }

    weak var delegate : ProfileHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        changeTheSelectionState()
    }

    private func changeTheSelectionState() {
        switch selectedSegment {
        case .Read:
            readSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            wishSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            allBooksSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
        case .Wish:
            wishSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            readSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            allBooksSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
        case .AllBooks:
            allBooksSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            wishSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            readSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)

        }
    }

    @IBAction func readSegmentDidClick(sender: AnyObject) {
        selectedSegment = .Read
        delegate?.profileHeaderViewDidClickSegmentAt(.Read)
    }

    @IBAction func wishSegmentDidClick(sender: AnyObject) {
        selectedSegment = .Wish
        delegate?.profileHeaderViewDidClickSegmentAt(.Wish)
    }
    @IBAction func allBooksDidClick(sender: AnyObject) {
        selectedSegment = .AllBooks
        delegate?.profileHeaderViewDidClickSegmentAt(.AllBooks)
    }
}
