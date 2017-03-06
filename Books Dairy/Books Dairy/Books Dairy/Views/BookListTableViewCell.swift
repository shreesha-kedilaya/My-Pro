//
//  BookListTableViewCell.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit
protocol BookListTableViewCellDelegate : class {
    func bookListTableViewCellDidSelectNextButtonAt(_ index : Int)
    func readButtonDidClickAt(_ index:Int)
    func wishButtonDidClickAt(_ index:Int)
}

class BookListTableViewCell: UITableViewCell {

    static let storyboardId = "BookListTableViewCell"

    @IBOutlet weak var bookShelfView: UIView!
    @IBOutlet weak var wishButton: UIButton?
    @IBOutlet weak var ratingView: BookRatingView!
    @IBOutlet weak var nextButton: UIButton?
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var readButton: UIButton?
    @IBOutlet weak var bookNameLabel: UILabel!
    var highlightColor = UIColor(red: 30/255, green: 66/255, blue: 117/255, alpha: 1)
    var unhighlightedColor = UIColor.white
    var index = 0
    var rating = 0 {
        didSet {
            ratingView.initialRatings = rating
        }
    }

    var readingCategory = BookCategory.ReadingCategory.none {
        didSet {
            switch readingCategory {
            case .readList:
                readButton?.backgroundColor = highlightColor
                wishButton?.backgroundColor = unhighlightedColor
            case .wishList:
                readButton?.backgroundColor = unhighlightedColor
                wishButton?.backgroundColor = highlightColor
            case .none :
                readButton?.backgroundColor = unhighlightedColor
                wishButton?.backgroundColor = unhighlightedColor
            }
        }
    }
    weak var delegate : BookListTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        readButton?.backgroundColor = unhighlightedColor

        readButton?.layer.cornerRadius = 3
        wishButton?.layer.cornerRadius = 3
        wishButton?.backgroundColor = unhighlightedColor
        addShadowToTheContainer()

    }
    @IBAction func readButtonDidClick(_ sender: AnyObject) {
        readingCategory = .readList
        delegate?.readButtonDidClickAt(index)
    }
    fileprivate func addShadowToTheContainer() {
        bookShelfView.layer.shadowRadius = 5
        bookShelfView.layer.shadowOpacity = 0.5

        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        backgroundColor = UIColor.white
    }
    @IBAction func wishButtonDidClick(_ sender: AnyObject) {
        readingCategory = .wishList
        delegate?.wishButtonDidClickAt(index)
    }

    @IBAction func nextButtonDidClick(_ sender: AnyObject) {

        delegate?.bookListTableViewCellDidSelectNextButtonAt(index)

    }
}

extension BookListTableViewCell : BookRatingViewDelegate {
    func bookRatingViewDidSelectRatingButtonsUptoIndex(_ ratingIndex: Int) {

    }
}
