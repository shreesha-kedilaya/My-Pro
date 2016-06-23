//
//  ModalPresentationViewController.swift
//  ModalPresentation
//
//  Created by Shreesha on 19/01/16.
//  Copyright © 2016 YML. All rights reserved.
//

import UIKit

class ModalPresentationViewController: UIViewController, UIViewControllerTransitioningDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    private var customAnimator : Animator?

    private var images = [UIImage(named: "listings1"),UIImage(named: "listings2.jpg"),UIImage(named: "listings3.jpg"),UIImage(named: "listings4.jpg"),]

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.pagingEnabled = true
        navigationController?.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCollectionViewCell", forIndexPath: indexPath) as? ImageCollectionViewCell

        cell?.imageView.image = images[indexPath.item]
        cell?.layoutSubviews()
        return cell!
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 200)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "present" {

            let vc = segue.destinationViewController as? PresentedViewController
            let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! ImageCollectionViewCell
            vc?.image = cell.imageView.image

            vc?.finalFrameForImageView = cell.convertRect(cell.frame, toView: view)
            
            vc?.modalPresentationStyle = UIModalPresentationStyle.Custom
            customAnimator = Animator(mainViewController: self, presentedViewController: vc!, presentWithImageView: cell.imageView, withRect: cell.imageView.bounds, dissmissWithImageView: cell.imageView)

            vc?.transitioningDelegate = customAnimator

        }
    }
}
