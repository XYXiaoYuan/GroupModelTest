//
//  UIView+BackImage.swift
//  Pods-RSExtension_Example
//
//  Created by 李强会 on 2020/7/18.
//

import UIKit

extension UIView {
    
    /// set view background color maked from uimage
    public func ff_setBackgroundImage(ff_image:String){
        UIGraphicsBeginImageContext(self.frame.size);
        UIImage(named: ff_image)?.draw(in: self.frame)
        let ff_img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundColor = UIColor.init(patternImage: ff_img!)
    }
}
