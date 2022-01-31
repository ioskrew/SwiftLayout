//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<Superview, Sub>: AttachableLayout, LayoutContainable where Superview: UIView, Sub: AttachableLayout {
    
    internal init(superview: Superview, subLayout: Sub) {
        self.view = superview
        self.subLayout = subLayout
    }
    
    let view: Superview
    let subLayout: Sub
    
    public var layouts: [AttachableLayout] { [subLayout] }
   
    public func deactive() {
        view.deactive()
        subLayout.deactive()
    }
    
    public func attachLayout(_ layout: AttachableLayout) {
        layout.addSubview(view)
        subLayout.attachLayout(self)
    }
    
    public func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    public var equation: AnyHashable {
        let superHash = view.equation
        let subHash = subLayout.equation
        return AnyHashable([superHash, subHash])
    }
    
}
