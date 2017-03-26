//
//  CustomPrintPageRenderer.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 3/25/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class CustomPrintPageRenderer: UIPrintPageRenderer {

    let A4PageWidth: CGFloat = 595.2
    
    let A4PageHeight: CGFloat = 841.8
    
    override init() {
        super.init()
       
        self.headerHeight = 20.0
        self.footerHeight = 50.0
        
        // Specify the frame of the A4 page.
        let pageFrame = CGRect(x: 0.0, y: 0.0, width: A4PageWidth, height: A4PageHeight)
        
        // Set the page frame.
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        
        // Set the horizontal and vertical insets (that's optional).
        //self.setValue(NSValue(cgRect: pageFrame), forKey: "printableRect")
        self.setValue(NSValue(cgRect: pageFrame.insetBy(dx: 70.0, dy: 40.0)), forKey: "printableRect")

    }
    
    override func drawHeaderForPage(at pageIndex: Int, in headerRect: CGRect) {
        
        if pageIndex == 0 {
            // Specify the header text.
            let headerText: NSString = "Snowball"
        
            // Set the desired font.
            let font = UIFont(name: "DIN", size: 30.0)
        
            // Specify some text attributes we want to apply to the header text.
            let textAttributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(red: 67.0/255, green: 219.0/255.0, blue: 2400.0/255.0, alpha: 1.0), NSKernAttributeName: 7.5] as [String : Any]
        
    
            // Calculate the text size.
            let textSize = getTextSize(text: headerText as String, font: nil, textAttributes: textAttributes as [String : AnyObject]!)
            
            let offsetX: CGFloat = 40.0
            
            // Specify the point that the text drawing should start from.
            let pointX = offsetX
            let pointY = headerRect.size.height/2 - textSize.height/2 + 20
            
            // Draw the header text.
            headerText.draw(at: CGPoint(x: pointX, y: pointY), withAttributes: textAttributes)
        }
    }
    
    override func drawFooterForPage(at pageIndex: Int, in footerRect: CGRect) {
        if pageIndex == self.numberOfPages - 1 {
            let footerText: NSString = "Thanks for reading! Download our app from the App Store if you haven't already!"
        
            let font = UIFont(name: "Noteworthy-Bold", size: 14.0)
            let textSize = getTextSize(text: footerText as String, font: font!)
        
            let centerX = footerRect.size.width/2 - textSize.width/2
            let centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2
            let attributes = [NSFontAttributeName: font!, NSForegroundColorAttributeName: UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255, alpha: 1.0)]
        
            footerText.draw(at: CGPoint(x: centerX,y: centerY), withAttributes: attributes)
        }
    }
    
    func getTextSize(text: String, font: UIFont!, textAttributes: [String: AnyObject]! = nil) -> CGSize {
        let testLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.paperRect.size.width, height: footerHeight))
        if let attributes = textAttributes {
        testLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
        else {
            testLabel.text = text
            testLabel.font = font!
        }
    
        testLabel.sizeToFit()
    
        return testLabel.frame.size
    }
    
}
