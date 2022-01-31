//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout {
    @discardableResult
    func active() -> AnyLayout
    func deactive()
    
    var equation: AnyHashable { get }
}

public protocol AttachableLayout: Layout {
    func attachLayout(_ layout: AttachableLayout)
    func addSubview(_ view: UIView)
}

extension AttachableLayout {
    
    public func addSubview(_ view: UIView) {}
    
}

extension AttachableLayout where Self: LayoutContainable {
    
    public func active() -> AnyLayout {
        layouts.forEach({ $0.attachLayout(self) })
        return AnyLayout(self)
    }
    
}
