//
//  Ex_PrimaryType.swift
//  xxxxx
//
//  Created by xx on 2017/5/18.
//  Copyright © 2017年 xx. All rights reserved.
//

import Foundation



// MARK: -  generate random number
extension Int {
    
    var lessThan : Int{
        get{
            return Int(arc4random_uniform( UInt32(self)))
        }
        
    }
    
}


// MARK: - extension URL
extension URL {
    
    
///    non-nil constructor
    public init(safeString string: String) {
        guard let instance = URL(string: string) else {
            
            fatalError("Unconstructable URL: \(string)")
        }
        self = instance
    }
}
// MARK: - extension Array
extension Array{
    

    var maxIndex : Int{
        get{
            #if DEBUG
                assert(self.count > 0 , "Array have not element")
            #else
            #endif
            return self.count-1
        }
    }
}
