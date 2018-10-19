//
//  Ex_TableCell.swift
//  worldPorject
//
//  Created by dengqi on 2018/1/31.
//  Copyright © 2018年 XXX. All rights reserved.
//

import Foundation
import UIKit

typealias TableViewProtocol = UITableViewDelegate&UITableViewDataSource
typealias CollectonViewProtocol = UICollectionViewDataSource&UICollectionViewDelegate
@objc protocol AdjustFrameAble {}

extension AdjustFrameAble where Self:UITableViewCell {
    var defaultMargin: CGFloat {
        return 6.0
    }
    
    func adjustFrame(_ frame: CGRect)-> CGRect{
        return adjustFrame(frame,x: defaultMargin, y: 0, width: 2*defaultMargin, height: defaultMargin)
    }
    
    func adjustFrame(_ frame: CGRect,x: CGFloat, y: CGFloat , width: CGFloat, height: CGFloat ) -> CGRect{
        
        var frame = frame
        frame.origin.x += x
        frame.origin.y -= y
        frame.size.height -= height
        frame.size.width -= width
        return frame
        
    }
}
