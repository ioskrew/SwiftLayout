//
//  PairLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct PairLayout<Left, Right>: AttachableLayout, LayoutContainable where Left: AttachableLayout, Right: AttachableLayout {
    
    let left: Left
    let right: Right
    
    public var layouts: [AttachableLayout] { [left, right] }
    
    public func active() -> AnyLayout {
        AnyLayout(self)
    }
    
    public func deactive() {
        left.deactive()
        right.deactive()
    }
    
    public func attachLayout(_ layout: AttachableLayout) {
        left.attachLayout(layout)
        right.attachLayout(layout)
    }
    
    public var equation: AnyHashable {
        AnyHashable([left.equation, right.equation])
    }
    
}
