//
//  UserAddingViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 29/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum UserEditingType {
    case Add
    case Edit
}

class UserAddingViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!

    var userAddType = UserEditingType.Add
    var viewModel = UserAddingViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = userAddType == .Add ? "Add User" : "Edit User"

        addButton.setTitle((userAddType == .Add ? "Add" : "Edit"), forState: .Normal)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonDidClick(sender: AnyObject) {

        viewModel.addTheUserToCoreData(userNameField.text, info: infoTextView.text) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    @IBAction func cancelButtonDidClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
