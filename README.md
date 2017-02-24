# SGSegmentedControl
![image](https://github.com/YuanJiaShuai/SGSegmentedControl/blob/master/tip1.gif) 
可通过属性设置是否需要滚动和禁止已经选择风格

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
    
    
    enum SGSegmentedControlType {
    /**滚动风格*/
    case SGSegmentedControlTypeScroll
    /**静止风格*/
    case SGSegmentedControlTypeStatic
  }

  enum SGSegmentedControlIndicatorType {
    /**指示器底部样式*/
    case SGSegmentedControlIndicatorTypeBottom
    /**指示器背景样式*/
    case SGSegmentedControlIndicatorTypeCenter
    /**指示器背景样式*/
    case SGSegmentedControlIndicatorTypeBankground
  }
