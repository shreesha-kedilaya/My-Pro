//
//  UserAddingViewController.swift
//  Books Dairy
//
//  Created by Shreesha on 29/06/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

enum UserEditingType {
    case add
    case edit
}

class UserAddingViewController: UIViewController {

    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!

    var userAddType = UserEditingType.add
    var viewModel = UserAddingViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()

        title = userAddType == .add ? "Add User" : "Edit User"

        addButton.setTitle((userAddType == .add ? "Add" : "Edit"), for: UIControlState())
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonDidClick(_ sender: AnyObject) {

        viewModel.addTheUserToCoreData(userNameField.text, info: infoTextView.text) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func cancelButtonDidClick(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
