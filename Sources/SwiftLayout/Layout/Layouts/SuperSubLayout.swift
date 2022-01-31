//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<SuperView, Sub>: ContainLayout where SuperView: UIView, Sub: Layout {
    
    internal init(superview: SuperView, subLayout: Sub) {
        self.view = superview
        self.subLayout = subLayout
    }
    
    let view: SuperView
    let subLayout: Sub
    
    public func active() -> AnyLayout {
        return AnyLayout(self)
    }
    
    public func deactive() {
        
    }
    
    public func attachViewLayout(_ viewlayout: ViewLayout) {
        viewlayout.addSubview(view)
    }
    
    public var equation: AnyHashable {
        let superHash = view.equation
        let subHash = subLayout.equation
        return AnyHashable([superHash, subHash])
    }
    
}

public extension SuperSubLayout where Sub: ContainLayout {
    @discardableResult
    func active() -> AnyLayout {
        subLayout.attachViewLayout(view)
        return AnyLayout(self)
    }
}

public extension SuperSubLayout where Sub: ViewLayout {
    @discardableResult
    func active() -> AnyLayout {
        subLayout.attachSuperlayout(view)
        return AnyLayout(self)
    }
}
