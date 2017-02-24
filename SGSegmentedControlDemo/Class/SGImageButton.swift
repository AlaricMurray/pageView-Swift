//
//  SGImageButton.swift
//  SGSegmentedControlDemo
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 YJS. All rights reserved.
//

import UIKit

class SGImageButton: UIButton {

    override func awakeFromNib() {
        self.titleLabel?.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //调整图片
        self.imageView?.SG_y = 5
        self.imageView?.SG_centerX = self.SG_width * 0.5
        
        //调整文字
        self.titleLabel?.SG_x = 0
        self.titleLabel?.SG_y = (self.imageView?.SG_bottom)! + 5
        self.titleLabel?.SG_height = self.SG_height - self.titleLabel!.SG_y - self.imageView!.SG_y
        self.titleLabel!.SG_width = self.SG_width
    }

}
