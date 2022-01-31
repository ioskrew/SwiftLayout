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

public protocol ViewLayout {
    func attachSuperlayout(_ superlayout: ViewLayout)
    func addSubview(_ view: UIView)
}

public protocol ContainLayout: Layout {
    func attachViewLayout(_ viewlayout: ViewLayout)
}

extension UIView: ViewLayout {
    var view: UIView { self }
    
    public func attachSuperlayout(_ superlayout: ViewLayout) {
        superlayout.addSubview(self)
    }
}
