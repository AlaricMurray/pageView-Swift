//
//  ViewController.swift
//  SGSegmentedControlDemo
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 YJS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, SGSegmentedControlDelegate {

    var mainScrollView : UIScrollView!
    var SG = SGSegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        setupChildViewController()
        setupSegmentedControl()
        self.title = "King"
        // Do any additional setup after loading the view.
    }
    
    func setupSegmentedControl() {
        let title_arr = ["精选", "电视剧", "电影", "综艺", "段子", "视屏", "养生"]
        mainScrollView = UIScrollView.init()
        mainScrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        mainScrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * CGFloat(title_arr.count), height: 0)
        mainScrollView.backgroundColor = UIColor.clear
        mainScrollView.isPagingEnabled = true
        mainScrollView.bounces = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        self.view.addSubview(mainScrollView)
        
        SG = SGSegmentedControl.init(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 44)).initWithFrame(CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: 44), delegate: self, segmentedControlType: .sgSegmentedControlTypeScroll, titleArr: title_arr as NSArray)
        SG.titleColorStateSelected = UIColor.purple
        SG.indicatorColor = UIColor.purple
        SG.backgroundColor = UIColor.purple
        self.view.addSubview(SG)
    }
    
    func setupChildViewController() {
        let oneVc = OneViewController.init()
        self.addChildViewController(oneVc)
        
        let twoVc = TwoViewController.init()
        self.addChildViewController(twoVc)
        
        let threeVc = ThreeViewController.init()
        self.addChildViewController(threeVc)
        
        let fourVc = FourViewController.init()
        self.addChildViewController(fourVc)
        
        let fiveVc = FiveViewController.init()
        self.addChildViewController(fiveVc)
        
        let sixVc = SixViewController.init()
        self.addChildViewController(sixVc)
        
        let seventVc = SevenViewController.init()
        self.addChildViewController(seventVc)
    }
    
    func SGSegmentControl(_ segmentControl: SGSegmentedControl, didSelectBtnAtIndex index: NSInteger) {
        // 1 计算滚动的位置
        let offsetX = CGFloat(index) * self.view.frame.size.width
        self.mainScrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        
        // 2.给对应位置添加对应子控制器
        showVc(index)
    }
    
    // 显示控制器的view
    func showVc(_ index : NSInteger) {
        let offsetX = CGFloat(index) * self.view.frame.size.width
        
        let vc = self.childViewControllers[index]
        
        if vc.isViewLoaded {
            return
        }
        vc.view.frame = CGRect(x: offsetX, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.mainScrollView.addSubview(vc.view)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = NSInteger(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        showVc(index)
        
        self.SG.titleBtnSelectedWithScrollView(scrollView)
    }


}

