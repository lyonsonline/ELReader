//
//  Util.swift
//  ElSegmentDemo
//
//  Created by Lyons Eric on 2017/3/24.
//  Copyright © 2017年 Lyons Eric. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    //水平等间隔排列
    func distributeSpacingHorizontally(with views: [UIView]) {
        var spaces: [UIView] = []
        for _ in 0...views.count {
            spaces.append(UIView(frame: .zero))
        }
        spaces.forEach { (v) in
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(v.snp.height)
            })
        }
        let firstSpace = spaces.first!
        firstSpace.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.centerY.equalTo(views[0].snp.centerY)
        }
        var lastSpace = firstSpace
        
        for (index, view) in views.enumerated() {
            let space = spaces[index + 1]
            view.snp.makeConstraints { (make) in
                make.left.equalTo(lastSpace.snp.right)
            }
            space.snp.makeConstraints { (make) in
                make.left.equalTo(view.snp.right)
                make.centerY.equalTo(view.snp.centerY)
                make.width.equalTo(firstSpace.snp.width)
            }
            lastSpace = space
        }
        lastSpace.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right)
        }
    }
    //垂直等间隔排列
    func distributeSpacingVertically(with views: [UIView]) {
        var spaces: [UIView] = []
        for _ in 0...views.count {
            spaces.append(UIView(frame: .zero))
        }
        spaces.forEach { (v) in
            self.addSubview(v)
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(v.snp.height)
            })
        }
        let firstSpace = spaces.first!
        firstSpace.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.centerX.equalTo(views[0].snp.centerX)
        }
        var lastSpace = firstSpace
        
        for (index, view) in views.enumerated() {
            let space = spaces[index + 1]
            view.snp.makeConstraints { (make) in
                make.top.equalTo(lastSpace.snp.bottom)
            }
            space.snp.makeConstraints { (make) in
                make.top.equalTo(view.snp.bottom)
                make.centerX.equalTo(view.snp.centerX)
                make.width.equalTo(firstSpace.snp.width)
            }
            lastSpace = space
        }
        lastSpace.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom)
        }
    }
}
