//
//  NCNSObjectExtension.swift
//  xxxxx
//
//  Created by xx on 2017/4/13.
//  Copyright © 2017年 xx. All rights reserved.
//

import Foundation


public extension NSObject{
    
    public class var className: String{
        
        //        NSStringFromClass(self) -->   "xxxxx.AnnounceHallCell"
        return  NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    public var className: String{
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        
    }
   
}
