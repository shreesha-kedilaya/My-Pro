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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let size = CGSize(width: 200, height: 400)

        flowLayout = MDCollectionViewFlowLayout(size: size, aspectRatio: 0.85)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 50
        flowLayout.minimumLineSpacing = 0.0

        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MDCCollectionViewCell.kReuseIdentifier, for: indexPath) as? MDCCollectionViewCell
        cell?.contentView.backgroundColor = UIColor.blue
        cell?.textLabel.text = "\(indexPath.item)"
        cell?.textLabel.textColor = UIColor.white
        return cell!
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: collectionView.frame.size.height - 30)
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

