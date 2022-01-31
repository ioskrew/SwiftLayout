//
//  SuperSubLayout.swift
//  
//
//  Created by oozoofrog on 2022/01/31.
//

import Foundation
import UIKit

public struct SuperSubLayout<SuperView, Sub>: Layout, ViewLayout where SuperView: UIView, Sub: Layout {
    
    internal init(superview: SuperView, subLayout: Sub) {
        self.view = superview
        self.subLayout = subLayout
    }
    
    let view: SuperView
    let subLayout: Sub
    
    func addSubview(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    func attachSuperlayout(_ superlayout: ViewLayout) {
        superlayout.addSubview(view)
    }
    
    public var equation: AnyHashable {
        let superHash = view.equation
        let subHash = subLayout.equation
        return AnyHashable([superHash, subHash])
    }
    
}

extension SuperSubLayout where Sub: ViewLayout {
    func active() -> AnyLayout {
        self.subLayout.attachSuperlayout(self)
        return AnyLayout(self)
    }
}
