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

    fileprivate let refreshaControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialAppearence()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        Async.after(0.0) {
            self.viewModel.fetchUsers{
                self.usersTableView.reloadData()
            }
        }
        if let users = viewModel.users , users.count > 0{
            title = "Users"
        } else {
            title = "Tap on 'Add' to add Users"
        }
    }

    fileprivate func initialAppearence() {
        refreshaControl.tintColor = UIColor.white

        refreshaControl.addTarget(self, action: #selector(UsersViewController.refresh), for: .valueChanged)
        usersTableView.addSubview(refreshaControl)
        usersTableView.separatorStyle = .none

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = viewModel.users , users.count > 0 {
            return users.count
        } else {
            return 0
        }


    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as? UsersTableViewCell
        cell?.selectionStyle = .none
        if let user = viewModel.users?[(indexPath as NSIndexPath).row] {
            cell?.index = (indexPath as NSIndexPath).row
            cell?.userNameLabel.text = user.name
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteTheUserAt((indexPath as NSIndexPath).row) {
                Async.main{
                    self.usersTableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}
extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookListVC = storyboard?.instantiateViewController(withIdentifier: "BookListViewController") as? BookListViewController
        if let user = viewModel.users?[(indexPath as NSIndexPath).row] {
            bookListVC?.viewModel.user = user
        }
        navigationController?.pushViewController(bookListVC!, animated: true)
    }
}

extension UsersViewController : UsersTableViewCellDelegate {
    func usersTableViewCellDidSelectEditButtunAtIndex(_ index: Int) {
        let userAddVC = storyboard?.instantiateViewController(withIdentifier: "UserAddingViewController") as? UserAddingViewController
        userAddVC?.userAddType = .edit
        navigationController?.present(userAddVC!, animated: true, completion: nil)
    }
}
