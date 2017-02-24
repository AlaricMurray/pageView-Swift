//
//  SGSegmentedControl.swift
//  SGSegmentedControlDemo
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 YJS. All rights reserved.
//

import UIKit

enum SGSegmentedControlType {
    /**滚动风格*/
    case sgSegmentedControlTypeScroll
    /**静止风格*/
    case sgSegmentedControlTypeStatic
}

enum SGSegmentedControlIndicatorType {
    /**指示器底部样式*/
    case sgSegmentedControlIndicatorTypeBottom
    /**指示器背景样式*/
    case sgSegmentedControlIndicatorTypeCenter
    /**指示器背景样式*/
    case sgSegmentedControlIndicatorTypeBankground
}

protocol SGSegmentedControlDelegate : NSObjectProtocol {
    /**
     代理方法
     - parameter segmentControl: SGSegmentedControl
     - parameter index:          所选按钮索引
     */
    func SGSegmentControl(_ segmentControl: SGSegmentedControl, didSelectBtnAtIndex index: NSInteger);
}

class SGSegmentedControl: UIScrollView {
    /** 按钮之间的间距(滚动时按钮之间的间距) */
    let btn_Margin : CGFloat = 15.0
    
    /** 按钮字体的大小(字号) */
    let btn_fondOfSize : CGFloat = 17.0
    
    /** 指示器的高度 */
    let indicatorViewHeight : CGFloat = 2.0
    
    /** 点击按钮时, 指示器的动画移动时间 */
    let indicatorViewTimeOfAnimation : CGFloat = 0.4
    
    /** 标题按钮 */
    var title_btn : UIButton?
    
    /** 带有图片的标题按钮 */
    var image_title_btn : SGImageButton?
    
    /**存入所有标题按钮*/
    lazy var titleBtn_mArr:NSMutableArray = { [] }()
    
    /** 普通状态下的图片数组 */
    var nomal_image_Arr : NSArray?
    
    /** 选中状态下的图片数组 */
    var selected_image_Arr : NSArray?
    
    /** 标题数组 */
    var title_Arr : NSArray?
    
    /** 指示器 */
    var indicatorView : UIView?
    
    /** 背景指示器下面的小indicatorView */
    var bgIndicatorView : UIView?
    
    /** 临时button用来转换button的点击状态 */
    var temp_btn : UIButton?
    
    /** 默认为滚动风格 */
    var segmentedControlType : SGSegmentedControlType?
    
    /** 标题文字颜色(默认为黑色) */
    var titleColorStateNormal : UIColor?
    
    /** 选中时标题文字颜色(默认为红色) */
    var titleColorStateSelected : UIColor?
    
    /** 指示器的颜色(默认为红色) */
    var indicatorColor : UIColor?
    
    /** 是否显示底部滚动指示器(默认为YES, 显示) */
    var showsBottomScrollIndicator : Bool?
    
    /** 指示器样式(默认为底部样式) */
    var segmentedControlIndicatorType : SGSegmentedControlIndicatorType?
    
    /**代理*/
    var delegate_SG : SGSegmentedControlDelegate?
    
    /** 标题文字渐变效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效*/
    var titleColorGradualChange : Bool?
    
    /** 标题文字缩放效果(默认为NO), 与titleBtnColorGradualChangeScrollViewDidScroll方法，一起才会生效*/
    var titleFondGradualChange : Bool?
    
    /**对象方法创建 SGSegmentedControl*/
    func initWithFrame(_ frame: CGRect, delegate : SGSegmentedControlDelegate, segmentedControlType: SGSegmentedControlType, titleArr : NSArray) -> Self {
        self.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.delegate_SG = delegate
        self.segmentedControlType = segmentedControlType
        self.title_Arr = titleArr
        self.setupTitleArr()
        return self
    }
    
    /** 创建标题按钮 */
    func setupTitleArr() {
        if self.segmentedControlType == .sgSegmentedControlTypeScroll {
            var button_X : CGFloat = 0.0
            let button_Y : CGFloat = 0.0
            let button_H : CGFloat = self.frame.size.height
            
            var i = 0
            for text in self.title_Arr! {
                
                /** 创建滚动时的标题Label */
                self.title_btn = UIButton(type: .custom)
                
                self.title_btn?.titleLabel?.font = UIFont.systemFont(ofSize: self.btn_fondOfSize)
                self.title_btn!.tag = i
                
                // 计算内容的Size
                let buttonSize = self.sizeWithText(text as! NSString, font: UIFont.systemFont(ofSize: self.btn_fondOfSize), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: button_H))
                
                // 计算内容的宽度
                let button_W = 2 * self.btn_Margin + buttonSize.width
                self.title_btn?.frame = CGRect(x: button_X, y: button_Y, width: button_W, height: button_H)
                
                self.title_btn?.setTitle(text as? String, for: UIControlState())
                self.title_btn?.setTitleColor(UIColor.black, for: UIControlState())
                self.title_btn?.setTitleColor(UIColor.red, for: .selected)
                
                // 计算每个label的X值
                button_X = button_X + button_W
                
                // 点击事件
                self.title_btn?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                // 默认选中第0个button
                if i == 0 {
                    self.buttonAction(self.title_btn!)
                }
                
                // 存入所有的title_btn
                self.titleBtn_mArr.add(self.title_btn!)
                self.addSubview(self.title_btn!)
                
                i = i + 1
            }
            
            // 计算scrollView的宽度
            let scrollViewWidth : CGFloat = (self.subviews.last?.frame)!.maxX
            self.contentSize = CGSize(width: scrollViewWidth, height: self.frame.size.height)
            
            // 取出第一个子控件
            let firstButton = self.subviews.first as! UIButton
            
            // 添加指示器
            self.indicatorView = UIView()
            self.indicatorView?.backgroundColor = UIColor.red
            self.indicatorView?.SG_height = indicatorViewHeight
            self.indicatorView?.SG_y = self.frame.size.height - 2 * indicatorViewHeight
            self.addSubview(self.indicatorView!)
            
            // 指示器默认在第一个选中位置
            // 计算TitleLabel内容的Size
            let buttonSize : CGSize = self.sizeWithText((firstButton.titleLabel?.text)! as NSString, font: UIFont.systemFont(ofSize: self.btn_fondOfSize), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: self.frame.size.height))
            self.indicatorView?.SG_width = buttonSize.width
            self.indicatorView?.SG_centerX = firstButton.SG_centerX
        } else {
            // 计算scrollView的宽度
            let scrollViewWidth : CGFloat = self.frame.size.width
            var button_X : CGFloat = 0.0
            let button_Y : CGFloat = 0.0
            let button_W : CGFloat = scrollViewWidth / CGFloat((self.title_Arr?.count)!)
            let button_H : CGFloat = self.frame.size.height
            var i = 0
            for text in self.title_Arr! {
                // 创建静止时的标题Label
                self.title_btn = UIButton(type: .custom)
                self.title_btn?.titleLabel?.font = UIFont.systemFont(ofSize: self.btn_fondOfSize)
                self.title_btn!.tag = i
                // 计算title_btn的x值
                button_X = CGFloat(i) * button_W
                self.title_btn?.frame = CGRect(x: button_X, y: button_Y, width: button_W, height: button_H)
                
                self.title_btn?.setTitle(text as? String, for: UIControlState())
                self.title_btn?.setTitleColor(UIColor.black, for: UIControlState())
                self.title_btn?.setTitleColor(UIColor.red, for: .selected)
                // 点击事件
                self.title_btn?.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
                
                if i == 0 {
                    self.buttonAction(self.title_btn!)
                }
                
                // 存入所有的title_btn
                self.titleBtn_mArr.add(self.title_btn!)
                self.addSubview(self.title_btn!)
                
                i = i + 1
            }
            
            // 取出第一个子控件
            let firstButton = self.subviews.first as! UIButton
            
            // 添加指示器
            self.indicatorView = UIView()
            self.indicatorView?.backgroundColor = UIColor.red
            self.indicatorView?.SG_height = self.indicatorViewHeight
            self.indicatorView?.SG_y = self.frame.size.height - 2 * self.indicatorViewHeight
            self.addSubview(self.indicatorView!)
            
            // 指示器默认在第一个选中位置
            // 计算TitleLabel内容的Size
            let buttonSize : CGSize = self.sizeWithText((firstButton.titleLabel?.text)! as NSString, font: UIFont.systemFont(ofSize: self.btn_fondOfSize), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: self.frame.size.height))
            
            self.indicatorView?.SG_width = buttonSize.width
            self.indicatorView?.SG_centerX = firstButton.SG_centerX
        }
    }
    
    /**
     代理函数
     
     - parameter segmentControl: 当前控件
     - parameter index:          选择页面
     */
    func SGSegmentControl(_ segmentControl: SGSegmentedControl, didSelectBtnAtIndex index: NSInteger) {
        
    }
    
    /**按钮的点击事件*/
    func buttonAction(_ sender : UIButton) {
        /**1、让选中的标题居中*/
        if self.segmentedControlType == .sgSegmentedControlTypeScroll {
            self.titleBtnSelectededCenter(sender)
        }
        
        /**2、代理方法实现*/
        let index : NSInteger = sender.tag
        
        if ((self.delegate_SG?.responds(to: #selector(SGSegmentControl(_:didSelectBtnAtIndex:)))) != nil) {
            self.delegate_SG?.SGSegmentControl(self, didSelectBtnAtIndex: index)
        }
        
        /**3、改变指示器位置*/
        titleBtnSelected(sender)
        
    }
    
    /** 标题选中颜色改变以及指示器位置变化 */
    func titleBtnSelected(_ button : UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(indicatorViewTimeOfAnimation) * Int64(0.5) * Int64(NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            if self.temp_btn == nil {
                button.isSelected = true
                self.temp_btn = button
            }else if self.temp_btn != nil && self.temp_btn == button {
                button.isSelected = true
            }else if self.temp_btn != button && self.temp_btn != nil {
                self.temp_btn?.isSelected = false
                button.isSelected = true
                self.temp_btn = button
            }
        }
        
        if self.segmentedControlType == .sgSegmentedControlTypeScroll {
            // 改变指示器位置
            if self.segmentedControlIndicatorType == .sgSegmentedControlIndicatorTypeCenter {
                UIView.animate(withDuration: 0.20, animations: { 
                    self.indicatorView?.SG_width = button.SG_width - self.btn_Margin
                    self.indicatorView?.SG_centerX = button.SG_centerX
                })
            }else if self.segmentedControlIndicatorType == .sgSegmentedControlIndicatorTypeBankground {
                UIView.animate(withDuration: 0.20, animations: { 
                    self.indicatorView?.SG_width = button.SG_width
                    self.bgIndicatorView?.SG_width = button.SG_width
                    self.indicatorView?.SG_centerX = button.SG_centerX
                })
            }else {
                UIView.animate(withDuration: 0.20, animations: { 
                    self.indicatorView?.SG_width = button.SG_width - 2 * self.btn_Margin
                    self.indicatorView?.SG_centerX = button.SG_centerX
                })
            }
            
            // 2、让选中的标题居中
            self.titleBtnSelectededCenter(button)
            
        }else {
            // 改变指示器位置
            if self.segmentedControlIndicatorType == .sgSegmentedControlIndicatorTypeCenter {
                // 改变指示器位置
                UIView.animate(withDuration: 0.2, animations: {
                    // 计算内容的Size
                    let buttonSize : CGSize = self.sizeWithText((button.titleLabel?.text)! as NSString, font: UIFont.systemFont(ofSize: self.btn_fondOfSize), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: self.frame.size.height - self.indicatorViewHeight))
                    self.indicatorView?.SG_width = buttonSize.width + self.btn_Margin
                    self.indicatorView?.SG_centerX = button.SG_centerX
                })
            } else if self.segmentedControlIndicatorType == .sgSegmentedControlIndicatorTypeBankground {
                // 改变指示器位置
                self.indicatorView?.SG_width = self.SG_width / CGFloat((self.title_Arr?.count)!)
                self.indicatorView?.SG_centerX = button.SG_centerX
            }else {
                // 改变指示器位置
                UIView.animate(withDuration: 0.2, animations: {
                    // 计算内容的Size
                    let buttonSize : CGSize = self.sizeWithText((button.titleLabel?.text)! as NSString, font: UIFont.systemFont(ofSize: self.btn_fondOfSize), maxSize: CGSize(width: CGFloat(MAXFLOAT), height: self.frame.size.height - self.indicatorViewHeight))
                    self.indicatorView?.SG_width = buttonSize.width
                    self.indicatorView?.SG_centerX = button.SG_centerX
                })
            }
        }
    }
    
    /**
     *  计算文字尺寸
     *
     *  @param text    需要计算尺寸的文字
     *  @param font    文字的字体
     *  @param maxSize 文字的最大尺寸
     */
    func sizeWithText(_ text: NSString, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrs:Dictionary<String,UIFont> = [NSFontAttributeName : font]
        return text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    /** 滚动标题选中居中 */
    func titleBtnSelectededCenter(_ centerBtn : UIButton) {
        //计算偏移量
        var offsetX : CGFloat = centerBtn.center.x - UIScreen.main.bounds.size.width * 0.5
        
        if offsetX < 0 {
            offsetX = 0
        }
        
        // 获取最大滚动范围
        let maxOffsetX : CGFloat = self.contentSize.width - UIScreen.main.bounds.size.width
        
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }
        
        self.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    /** 标题选中颜色改变以及指示器位置变化 */
    func titleBtnSelectedWithScrollView(_ scrollView : UIScrollView) {
        // 1、计算滚动到哪一页
        let index = scrollView.contentOffset.x / scrollView.frame.size.width
        
        // 2、把对应的标题选中
        let selectedBtn = titleBtn_mArr[Int(index)] as! UIButton
        
        // 3、滚动时，改变标题选中
        self.titleBtnSelected(selectedBtn)
    }
    
    /** 给外界scrollViewDidScroll方法提供文字渐显效果 */
    func titleBtnColorGradualChangeScrollViewDidScroll(_ scrollView : UIScrollView) {
        let curPage = scrollView.contentOffset.x / scrollView.bounds.size.width
        
        // 左边label角标
        let leftIndex = curPage
        // 右边的label角标
        let rightIndex = leftIndex + 1
        
        // 获取左边的label
        let left_btn = titleBtn_mArr[Int(leftIndex)] as! UIButton
        
        // 获取右边的label
        var right_btn : UIButton?
        
        if rightIndex < CGFloat((self.titleBtn_mArr.count)) - 1 {
            right_btn = self.titleBtn_mArr[Int(rightIndex)] as? UIButton
        }
        
        // 计算下右边缩放比例
        let rightScale : CGFloat = curPage - leftIndex
        
        // 计算下左边缩放比例
        let leftScale : CGFloat = 1 - rightScale
        
        if self.titleFondGradualChange == true {
            // 左边缩放
            left_btn.transform = CGAffineTransform(scaleX: leftScale * 0.1 + 1, y: leftScale * 0.1 + 1)
            
            // 右边缩放
            right_btn?.transform = CGAffineTransform(scaleX: rightScale * 0.1 + 1, y: rightScale * 0.1 + 1)
        }
        
        if self.titleColorGradualChange == true {
            // 设置文字颜色渐变
            left_btn.titleLabel?.textColor = UIColor(red: leftScale, green: 0, blue: 0, alpha: 1)
            right_btn?.titleLabel?.textColor = UIColor(red: rightScale, green: 0, blue: 0, alpha: 1)
        }
    }

}


























