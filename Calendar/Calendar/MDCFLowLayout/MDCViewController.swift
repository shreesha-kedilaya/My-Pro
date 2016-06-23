//
//  ViewController.swift
//  MDCFLowLayout
//
//  Created by Shreesha on 17/05/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class MDCViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView : UICollectionView!

    var flowLayout :  MDCollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let size = CGSize(width: collectionView.bounds.size.width - 60, height: collectionView.bounds.size.height)

        let minSize = CGSize(width: collectionView.bounds.size.width - 80, height: collectionView.bounds.size.height - 200)
        
        flowLayout = MDCollectionViewFlowLayout(minimumSizeForItem: minSize, maximumSizeForItem: size)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = 0.0

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MDCCollectionViewCell.kReuseIdentifier, forIndexPath: indexPath) as? MDCCollectionViewCell
        cell?.contentView.backgroundColor = UIColor.blueColor()
        cell?.textLabel.text = "\(indexPath.item)"
        cell?.textLabel.textColor = UIColor.whiteColor()
        return cell!
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.height - 30)
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
    }
}

