//
//  ViewController.swift
//  RangeSelector
//
//  Created by Shreesha on 02/12/15.
//  Copyright © 2015 YML. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RangeSelectorDelegate, RangeSelectorDataSource {

    private var texts = ["1","2","3","4","5","6"]
    @IBOutlet weak var rangeSelector: RangeSelector!
    override func viewDidLoad() {
        super.viewDidLoad()
        rangeSelector.delegate = self
        rangeSelector.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicked(sender: AnyObject) {

        rangeSelector.reloadData(withAnimation: true)

    }
    func numberOfSegmentsForRangeSelector(rangeSelector: RangeSelector) -> Int {
        return 6
    }
    func startIndexForRangeSelector(rangeSelector: RangeSelector) -> Int {
        return 3
    }

    func endIndexForRangeSelector(rangeSelector: RangeSelector) -> Int {
        return 5
    }

    func textsForRangeSelector(rangeSelector: RangeSelector, atIndex index: Int) -> String {
        return texts[index]
    }

    func rangeSelector(rangeSelector : RangeSelector , movedFromIndex fromIndex : Int, toIndex : Int) {
//        print("Moved Range selector")
//
//        print("start", fromIndex)
//        print("End", toIndex)
    }

}

