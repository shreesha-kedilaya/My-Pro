        //
//  ViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController {

    @IBOutlet weak var tableViewBookList: UITableView!
    @IBOutlet weak var profileHeaderView: ProfileHeaderView!

    let refreshaControl = UIRefreshControl()

    var viewModel = BookListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialAppearence()
        viewModel.fetchAllData{
            self.updateTheUI()
            self.viewModel.currentBooks = self.viewModel.books
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "UserBooksNavigationController" {
            let userBookListNVC = segue.destinationViewController as? UINavigationController
            let userBookListVC = userBookListNVC?.visibleViewController as? UserBooksViewController
            if let ownedBooks = viewModel.getAllOwnedBooks() {
                userBookListVC?.viewModel.ownedBooks = ownedBooks
            }
            userBookListVC?.viewModel.user = viewModel.user
        } else if segue.identifier == "BookAddNavigationController" {
            let bookAddNVC = segue.destinationViewController as? UINavigationController
            let bookAddVC = bookAddNVC?.visibleViewController as? BookAddViewController
            bookAddVC?.delegate = self
        }
    }

    private func initialAppearence() {
        tableViewBookList.tableHeaderView = profileHeaderView

        refreshaControl.tintColor = UIColor.whiteColor()

        refreshaControl.addTarget(self, action: #selector(UsersViewController.refresh), forControlEvents: .ValueChanged)
        tableViewBookList.addSubview(refreshaControl)
        profileHeaderView.delegate = self

        title = "Books"
        updateTheHeaderView()
    }

    private func updateTheUI() {
        Async.main { 

            switch self.profileHeaderView.selectedSegment {
            case .AllBooks:
                self.viewModel.currentBooks = self.viewModel.books
            case .Read:
                self.viewModel.currentBooks = self.viewModel.readList
            case .Wish:
                self.viewModel.currentBooks = self.viewModel.wishList
            }
            self.tableViewBookList.reloadSections(NSIndexSet(index:0), withRowAnimation: .Automatic)
            self.updateTheHeaderView()
        }
    }

    private func updateTheHeaderView(){

        profileHeaderView.nameLabel.text = viewModel.user?.name
        profileHeaderView.departmentLabel.text = String(viewModel.user?.author_rating)

    }

    func refresh() {
        refreshaControl.beginRefreshing()
        viewModel.fetchAllData { 
            self.refreshaControl.endRefreshing()
            self.updateTheUI()
        }

    }
}

extension BookListViewController : UITableViewDelegate {

}

extension BookListViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BookListTableViewCell.storyboardId, forIndexPath: indexPath) as? BookListTableViewCell
        cell?.selectionStyle = .None
        cell?.layer.cornerRadius = 10
        cell?.index = indexPath.row
        cell?.delegate = self
        cell?.readingCategory = .None

        if let book = viewModel.currentBooks?[indexPath.row] {
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
            if let category = book.category {
                cell?.categoryLabel.text = "Category: " + category
            } else {
                cell?.categoryLabel.text = "Category: "
            }

            cell?.bookNameLabel.text = book.name

            if let averageRating = book.averageRating {
                if (averageRating as Float) <= 5 {
                    cell?.rating = Int(averageRating)
                    cell?.ratingLabel.text = String(averageRating)
                }
            } else {
                cell?.ratingLabel.text = String(0.0)
            }
//            if let readingCategory = book.readingListCategoty {
//                cell?.readingCategory = readingCategory
//            }
        }
        return cell!
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.currentBooks?.count {
            return count
        }
        return 0

    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
}

extension BookListViewController : ProfileHeaderViewDelegate {
    func profileHeaderViewDidClickSegmentAt(segment: SelectedSegement) {

        switch segment {
        case .AllBooks:
            viewModel.currentBooks = viewModel.books
        case .Read:
            viewModel.currentBooks = viewModel.readList
        case .Wish:
            viewModel.currentBooks = viewModel.wishList
        }

        updateTheUI()
    }
}
extension BookListViewController : BookListTableViewCellDelegate {

    func bookListTableViewCellDidSelectNextButtonAt(index: Int) {
        
    }

    func readButtonDidClickAt(index:Int) {
        let alertAction = UIAlertController(title: "Add to Read List", message: "Are you sure you want to add this book to the Read List", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Add To Read List", style: .Default) { (action) in
            if let currentBooks = self.viewModel.currentBooks {
                self.viewModel.addToReadList(currentBooks[index]) {
                    self.viewModel.fetchAllData({ 
                        self.updateTheUI()
                    })
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertAction.addAction(noAction)
        alertAction.addAction(yesAction)
        navigationController?.presentViewController(alertAction, animated: true, completion: nil)
    }

    func wishButtonDidClickAt(index:Int) {
        let alertAction = UIAlertController(title: "Add to Wish List", message: "Are you sure you want to add this book to the Wish List", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "Add To Wish List", style: .Default) { (action) in
            if let currentBooks = self.viewModel.currentBooks {
                self.viewModel.addToWishList(currentBooks[index]) {
                    self.viewModel.fetchAllData({
                        self.updateTheUI()
                    })
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        alertAction.addAction(noAction)
        alertAction.addAction(yesAction)
        navigationController?.presentViewController(alertAction, animated: true, completion: nil)
    }
}

extension BookListViewController: BookAddViewControllerDelegate {
    func bookAddViewController(controller : BookAddViewController, didSuccessfullyAddWithBook book: Book?, user: User?) {
        controller.dismissViewControllerAnimated(true) {

            self.viewModel.fetchUser{
                self.viewModel.fetchAllData {
                    self.updateTheUI()
                }
            }
        }
    }
}


