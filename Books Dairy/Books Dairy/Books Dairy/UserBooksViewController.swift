//
//  UserBooksViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 01/07/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class UserBooksViewController: UIViewController {

    @IBOutlet weak var usersBookTableView: UITableView!
    var viewModel = UserBookListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Your Books"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectDismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension UserBooksViewController : UITableViewDelegate {

}

extension UserBooksViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let books = viewModel.ownedBooks {
            return books.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookListTableViewCell.storyboardId, forIndexPath: indexPath) as? BookListTableViewCell
        cell?.selectionStyle = .None
        cell?.layer.cornerRadius = 10
        cell?.index = indexPath.row
        if let book = viewModel.ownedBooks?[indexPath.row] {
            if let authorName = book.authorName {
                cell?.authorLabel.text = "Author: " + authorName
            } else {
                cell?.authorLabel.text = "Author: "
            }
            if let details = book.details {
                cell?.detailsLabel.text = "Info: " + details
            } else {
                cell?.detailsLabel.text = "Info: "
            }
//            if let category = book.readingCategory {
//                cell?.categoryLabel.text = "Category: " + category
//            } else {
//                cell?.categoryLabel.text = "Category: "
//            }

            cell?.bookNameLabel.text = book.name

            if let averageRating = book.averageRating {
                cell?.rating = Int(averageRating)
                cell?.ratingLabel.text = String(averageRating)
            } else {
                cell?.ratingLabel.text = String(0.0)
            }
        }

        return cell!
        
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            viewModel.deleteBookAt(indexPath.row) {
                Async.main{
                    self.usersBookTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
}
