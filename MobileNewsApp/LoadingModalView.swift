//
//  LoginModalView.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 3/5/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class LoadingModalView: UIView {
    
    
    var stageLabel : UILabel? = nil
    var stageImage : UILabel? = nil
    
    init(frame:CGRect, text:String) {
        super.init(frame:frame)
        stageLabel = UILabel(frame: CGRect(x: 15, y: self.frame.height/2 - 15, width: self.frame.width - 30, height: 30))
        stageLabel?.textAlignment = .center
        stageLabel?.text = text
        self.backgroundColor = UIColor.white
        setup()
        
    }
    
    override init(frame:CGRect) {
        
        super.init(frame:frame)
        
        stageLabel = UILabel(frame: CGRect(x: 15, y: self.frame.height/2 - 15, width: self.frame.width - 30, height: 30))
        stageLabel?.textAlignment = .center
        
        setup()
    }

    
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    
    private func setup() {
        self.addSubview(stageLabel!)
//        self.addSubview(stageImage)
        // configure the initial layout of your subviews here.
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
