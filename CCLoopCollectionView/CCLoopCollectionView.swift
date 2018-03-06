//
//  LoopCollectionView.swift
//  TestLoopCollectionView
//
//  Created by cuicc on 2018/3/5.
//  Copyright © 2018年 cuicc. All rights reserved.
//

import UIKit
import SDWebImage

class CCLoopCollectionView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var mCollectionView: UICollectionView!
    private var loopPageControl: UIPageControl!
    
    private var currentFrame: CGRect!
    private var currentIndex = 1
    private var scrollTimer: Timer!
    
    /// 内容数组，可以是图片、本地路径或者网络路径
    var contentAry = [AnyObject]() {
        didSet {
            if contentAry.count > 1 {
                contentAry.insert(contentAry.last!, at: 0)
                contentAry.append(contentAry[1])
            }
            if mCollectionView != nil {
                loopPageControl.frame = CGRect(x: 0, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0)
                loopPageControl.numberOfPages = contentAry.count > 1 ? (contentAry.count - 2) : 1
                
                mCollectionView.reloadData()
                mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
    /// 是否开始自动循环
    var enableAutoScroll = false {
        didSet {
            if  mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    /// 循环间隔时间
    var timeInterval = 1.0 {
        didSet {
            if mCollectionView != nil && enableAutoScroll == true {
                configAutoScroll()
            }
        }
    }
    /// 图片的宽度
    let AD_WIDTH: CGFloat = 375.0
    /// 图片的高度
    let AD_HEIGHT: CGFloat = 160.0
    var currentPageControlColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
            }
        }
    }
    var pageControlTintColor: UIColor? {
        didSet {
            if mCollectionView != nil {
                loopPageControl.pageIndicatorTintColor = pageControlTintColor
            }
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        currentFrame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if currentFrame == nil {
            currentFrame = frame
        }
        initAllViews(frame: currentFrame)
    }
    func initAllViews(frame: CGRect) {
        // 图片循环UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        mCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.register(LoopCollectionViewCell.self, forCellWithReuseIdentifier: "LoopCollectionViewCellIdentifier")
        //
        mCollectionView.backgroundColor = UIColor.white
        mCollectionView.isPagingEnabled = true
        mCollectionView.showsHorizontalScrollIndicator = false
        self.superview?.addSubview(mCollectionView)
        if mCollectionView.numberOfItems(inSection: 0) > 0 {
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        //loopPageControl
        loopPageControl = UIPageControl(frame: CGRect(x: 0, y: currentFrame.origin.y+currentFrame.size.height-37.0, width: currentFrame.size.width, height: 37.0))
        loopPageControl.layer.borderColor = UIColor.red.cgColor
        loopPageControl.layer.borderWidth = 1.0
        loopPageControl.numberOfPages = contentAry.count > 1 ? (contentAry.count - 2) : 1
        loopPageControl.currentPageIndicatorTintColor = currentPageControlColor
        loopPageControl.pageIndicatorTintColor = pageControlTintColor
        self.superview?.addSubview(loopPageControl)
        
        
        // 是否开启自动循环
        if enableAutoScroll == true {
            configAutoScroll()
        }
    }
    
    
    
    //MARK: -  UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentAry.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * AD_HEIGHT / AD_WIDTH)
        return CGSize(width: currentFrame.size.width, height: currentFrame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoopCollectionViewCellIdentifier", for: indexPath) as? LoopCollectionViewCell
        if cell == nil {
            cell = LoopCollectionViewCell()
        }
        
        let content = contentAry[indexPath.item]
        if let realContent = content as? UIImage {
            cell?.contentImageView?.image = realContent
        }
        else if let realContent = content as? String, realContent.hasPrefix("http") {
            cell?.contentImageView?.sd_setImage(with: URL(string: realContent), placeholderImage: nil)
        }
        else if let realContent = content as? String, !realContent.hasPrefix("http") {
            cell?.contentImageView?.sd_setImage(with: URL(fileURLWithPath: realContent), placeholderImage: nil)
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    //MARK: -  UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        
        let index = Int(scrollView.contentOffset.x / currentFrame.size.width)
        currentIndex = index
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = contentAry.count-2
        }
        
        
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex-1
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
        
        let index = Int(scrollView.contentOffset.x / currentFrame.size.width)
        if index == contentAry.count-1 {
            mCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = 1
        }
        
        if index == 0 && contentAry.count > 1 {
            mCollectionView.scrollToItem(at: IndexPath(item: contentAry.count-2, section: 0), at: .centeredHorizontally, animated: false)
            currentIndex = contentAry.count-2
        }
        
        
        //更新loopPageControl
        loopPageControl?.currentPage = currentIndex-1
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = false
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
    
    
    
    //MARK: -  Custom
    
    func configAutoScroll() {
        //设置定时器
        if scrollTimer != nil {
            scrollTimer.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(autoScrollAction(timer:)), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollAction(timer: Timer) {
        if self.window != nil {
            currentIndex += 1
            if currentIndex >= contentAry.count {
                currentIndex = currentIndex % contentAry.count
            }
            mCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
