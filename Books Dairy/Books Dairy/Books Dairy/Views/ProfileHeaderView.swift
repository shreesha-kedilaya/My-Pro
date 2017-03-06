//
//  ProfileHeaderView.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum SelectedSegement {
    case read
    case wish
    case allBooks
}

protocol ProfileHeaderViewDelegate: class {
    func profileHeaderViewDidClickSegmentAt(_ segment : SelectedSegement)
}

class ProfileHeaderView: UIView {

    @IBOutlet weak var allBooksSegmentButton: UIButton!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var readSegmentButton: UIButton!
    @IBOutlet weak var wishSegmentButton: UIButton!
    var selectedSegment : SelectedSegement = .allBooks {
        didSet {
            changeTheSelectionState()
        }
    }

    weak var delegate : ProfileHeaderViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        changeTheSelectionState()
    }

    fileprivate func changeTheSelectionState() {
        switch selectedSegment {
        case .read:
            readSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            wishSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            allBooksSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
        case .wish:
            wishSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            readSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            allBooksSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
        case .allBooks:
            allBooksSegmentButton.backgroundColor = UIColor(red: 54/255, green: 107/255, blue: 206/255, alpha: 1.0)
            wishSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)
            readSegmentButton.backgroundColor = UIColor(red: 43/255, green: 85/255, blue: 162/255, alpha: 1.0)

        }
    }

    @IBAction func readSegmentDidClick(_ sender: AnyObject) {
        selectedSegment = .read
        delegate?.profileHeaderViewDidClickSegmentAt(.read)
    }

    @IBAction func wishSegmentDidClick(_ sender: AnyObject) {
        selectedSegment = .wish
        delegate?.profileHeaderViewDidClickSegmentAt(.wish)
    }
    @IBAction func allBooksDidClick(_ sender: AnyObject) {
        selectedSegment = .allBooks
        delegate?.profileHeaderViewDidClickSegmentAt(.allBooks)
    }
}
