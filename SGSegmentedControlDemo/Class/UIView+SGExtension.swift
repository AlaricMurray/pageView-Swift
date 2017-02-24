//
//  UIView+SGExtension.swift
//  SGSegmentedControlDemo
//
//  Created by apple on 16/11/9.
//  Copyright © 2016年 YJS. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public var SG_x : CGFloat{
        get{
            return self.frame.origin.x
        }
        set(newView){
            self.frame.origin.x = newView
        }
    }
    
    public var SG_y : CGFloat{
        get{
            return self.frame.origin.y
        }
        set(newView){
            self.frame.origin.y = newView
        }
    }
    
    public var SG_width : CGFloat{
        get{
            return self.frame.size.width
        }
        set(newView){
            self.frame.size.width = newView
        }
    }
    
    public var SG_height : CGFloat{
        get{
            return self.frame.size.height
        }
        set(newView){
            self.frame.size.height = newView
        }
    }
    
    public var SG_centerX : CGFloat{
        get{
            return self.center.x
        }
        set(newView){
            self.center.x = newView
        }
    }
    
    public var SG_centerY : CGFloat{
        get{
            return self.center.y
        }
        set(newView){
            self.center.y = newView
        }
    }
    
    public var SG_right : CGFloat{
        get{
            return self.frame.maxX
        }
        set(newView){
            self.SG_x = newView - self.SG_width
        }
    }
    
    public var SG_bottom : CGFloat{
        get{
            return self.frame.maxY
        }
        set(newView){
            self.SG_y = newView - self.SG_height
        }
    }
    
    public var SG_size : CGSize{
        get{
            return self.frame.size
        }
        set(newView){
            self.frame.size = newView
        }
    }
    
}
