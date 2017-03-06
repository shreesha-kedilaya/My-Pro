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
    
    @IBAction func didSelectDismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension UserBooksViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let books = viewModel.ownedBooks {
            return books.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
}

extension UserBooksViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookListTableViewCell.storyboardId, for: indexPath) as? BookListTableViewCell
        cell?.selectionStyle = .none
        cell?.layer.cornerRadius = 10
        cell?.index = (indexPath as NSIndexPath).row
        if let book = viewModel.ownedBooks?[(indexPath as NSIndexPath).row] {
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
                cell?.ratingLabel.text = String(describing: averageRating)
            } else {
                cell?.ratingLabel.text = String(0.0)
            }
        }

        return cell!
        
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteBookAt((indexPath as NSIndexPath).row) {
                Async.main{
                    self.usersBookTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
