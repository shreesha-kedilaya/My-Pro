//
//  UsersViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 27/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {

    @IBOutlet weak var usersTableView: UITableView!

    var viewModel = UserViewModel()

    private let refreshaControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialAppearence()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        Async.after(0.0) {
            self.viewModel.fetchUsers{
                self.usersTableView.reloadData()
            }
        }
        if let users = viewModel.users where users.count > 0{
            title = "Users"
        } else {
            title = "Tap on 'Add' to add Users"
        }
    }

    private func initialAppearence() {
        refreshaControl.tintColor = UIColor.whiteColor()

        refreshaControl.addTarget(self, action: #selector(UsersViewController.refresh), forControlEvents: .ValueChanged)
        usersTableView.addSubview(refreshaControl)
        usersTableView.separatorStyle = .None

    }

    func refresh() {
        refreshaControl.beginRefreshing()
        viewModel.fetchUsers {
            self.refreshaControl.endRefreshing()
            self.usersTableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension UsersViewController: UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = viewModel.users where users.count > 0 {
            return users.count
        } else {
            return 0
        }


    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UsersTableViewCell", forIndexPath: indexPath) as? UsersTableViewCell
        cell?.selectionStyle = .None
        if let user = viewModel.users?[indexPath.row] {
            cell?.index = indexPath.row
            cell?.userNameLabel.text = user.name
        }
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            viewModel.deleteTheUserAt(indexPath.row) {
                Async.main{
                    self.usersTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
}
extension UsersViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookListVC = storyboard?.instantiateViewControllerWithIdentifier("BookListViewController") as? BookListViewController
        if let user = viewModel.users?[indexPath.row] {
            bookListVC?.viewModel.user = user
        }
        navigationController?.pushViewController(bookListVC!, animated: true)
    }
}

extension UsersViewController : UsersTableViewCellDelegate {
    func usersTableViewCellDidSelectEditButtunAtIndex(index: Int) {
        let userAddVC = storyboard?.instantiateViewControllerWithIdentifier("UserAddingViewController") as? UserAddingViewController
        userAddVC?.userAddType = .Edit
        navigationController?.presentViewController(userAddVC!, animated: true, completion: nil)
    }
}
