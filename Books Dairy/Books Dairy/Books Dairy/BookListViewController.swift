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
            self.viewModel.currentBooks = self.viewModel.allBooks
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "UserBooksNavigationController" {
            let userBookListNVC = segue.destination as? UINavigationController
            let userBookListVC = userBookListNVC?.visibleViewController as? UserBooksViewController
            if let ownedBooks = viewModel.userBooks {
                userBookListVC?.viewModel.ownedBooks = ownedBooks
            }
            userBookListVC?.viewModel.user = viewModel.user
        } else if segue.identifier == "BookAddNavigationController" {
            let bookAddNVC = segue.destination as? UINavigationController
            let bookAddVC = bookAddNVC?.visibleViewController as? BookAddViewController
            bookAddVC?.delegate = self
        }
    }

    fileprivate func initialAppearence() {
        tableViewBookList.tableHeaderView = profileHeaderView

        refreshaControl.tintColor = UIColor.white

        refreshaControl.addTarget(self, action: #selector(UsersViewController.refresh), for: .valueChanged)
        tableViewBookList.addSubview(refreshaControl)
        profileHeaderView.delegate = self

        title = "Books"
        updateTheHeaderView()
    }

    fileprivate func updateTheUI() {
        Async.main { 

            switch self.profileHeaderView.selectedSegment {
            case .allBooks:
                self.viewModel.currentBooks = self.viewModel.allBooks
            case .read:
                self.viewModel.currentBooks = self.viewModel.readList
            case .wish:
                self.viewModel.currentBooks = self.viewModel.wishList
            }
            self.tableViewBookList.reloadSections(IndexSet(integer:0), with: .automatic)
            self.updateTheHeaderView()
        }
    }

    fileprivate func updateTheHeaderView(){

        profileHeaderView.nameLabel.text = viewModel.user?.name
        profileHeaderView.departmentLabel.text = String(describing: viewModel.user?.info)

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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookListTableViewCell.storyboardId, for: indexPath) as? BookListTableViewCell
        cell?.selectionStyle = .none
        cell?.layer.cornerRadius = 10
        cell?.index = (indexPath as NSIndexPath).row
        cell?.delegate = self
        cell?.readingCategory = .none

        if let book = viewModel.currentBooks?[(indexPath as NSIndexPath).row] {
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
                    cell?.ratingLabel.text = String(describing: averageRating)
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel.currentBooks?.count {
            return count
        }
        return 0

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
}

extension BookListViewController : ProfileHeaderViewDelegate {
    func profileHeaderViewDidClickSegmentAt(_ segment: SelectedSegement) {

        switch segment {
        case .allBooks:
            viewModel.currentBooks = viewModel.allBooks
        case .read:
            viewModel.currentBooks = viewModel.readList
        case .wish:
            viewModel.currentBooks = viewModel.wishList
        }

        updateTheUI()
    }
}

extension BookListViewController : BookListTableViewCellDelegate {

    func bookListTableViewCellDidSelectNextButtonAt(_ index: Int) {
        
    }

    func readButtonDidClickAt(_ index:Int) {
        let alertAction = UIAlertController(title: "Add to Read List", message: "Are you sure you want to add this book to the Read List", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Add To Read List", style: .default) { (action) in
            if let currentBooks = self.viewModel.currentBooks {
                self.viewModel.addToReadList(currentBooks[index]) {
                    self.viewModel.fetchAllData({ 
                        self.updateTheUI()
                    })
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertAction.addAction(noAction)
        alertAction.addAction(yesAction)
        navigationController?.present(alertAction, animated: true, completion: nil)
    }

    func wishButtonDidClickAt(_ index:Int) {
        let alertAction = UIAlertController(title: "Add to Wish List", message: "Are you sure you want to add this book to the Wish List", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Add To Wish List", style: .default) { (action) in
            if let currentBooks = self.viewModel.currentBooks {
                self.viewModel.addToWishList(currentBooks[index]) {
                    self.viewModel.fetchAllData({
                        self.updateTheUI()
                    })
                }
            }
        }
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertAction.addAction(noAction)
        alertAction.addAction(yesAction)
        navigationController?.present(alertAction, animated: true, completion: nil)
    }
}

extension BookListViewController: BookAddViewControllerDelegate {
    func bookAddViewController(_ controller : BookAddViewController, didSuccessfullyAddWithBook book: Book?, user: User?) {
        controller.dismiss(animated: true) {

            self.viewModel.fetchUser{
                self.viewModel.fetchAllData {
                    self.updateTheUI()
                }
            }
        }
    }
}


