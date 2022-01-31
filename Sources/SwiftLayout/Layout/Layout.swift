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

public extension Layout {
    func active() -> AnyLayout {
        AnyLayout(self)
    }
    
    func deactive() {}
}

protocol ViewLayout {
    func attachSuperlayout(_ superlayout: ViewLayout)
    func addSubview(_ view: UIView)
}

extension UIView: ViewLayout {
    var view: UIView { self }
    
    func attachSuperlayout(_ superlayout: ViewLayout) {
        superlayout.addSubview(self)
    }
}
