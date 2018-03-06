//
//  ViewController.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var adView: CCLoopCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        var tempAry = [String]()
        for i in 0..<5 {
            tempAry.append(Bundle.main.path(forResource: "\(i+1)", ofType: "jpeg")!)
        }
        
        
//        let tempAry = [#imageLiteral(resourceName: "1.jpeg"), #imageLiteral(resourceName: "2.jpeg"), #imageLiteral(resourceName: "3.jpeg"), #imageLiteral(resourceName: "4.jpeg"), #imageLiteral(resourceName: "5.jpeg")]
        adView.contentAry = tempAry as [AnyObject]
        adView.isHidden = true
        adView.enableAutoScroll = true
        adView.timeInterval = 2.0
        adView.currentPageControlColor = UIColor.red
        adView.pageControlTintColor = UIColor.black
        
        let v = CCLoopCollectionView(frame: CGRect(x: 0, y: 60, width: 175, height: 100))
        v.contentAry = tempAry as [AnyObject]
        v.enableAutoScroll = true
        v.timeInterval = 2.0
        v.currentPageControlColor = UIColor.brown
        v.pageControlTintColor = UIColor.cyan
        view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

