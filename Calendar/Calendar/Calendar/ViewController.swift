//
//  ViewController.swift
//  Calendar
//
//  Created by Shreesha on 12/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var reloadButton: UIButton!
    @IBOutlet weak var calendarView: CalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func reloadButtonAction(sender: AnyObject) {
        calendarView.reloadData()
    }
}

