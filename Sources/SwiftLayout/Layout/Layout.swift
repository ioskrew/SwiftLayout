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

public extension Layout where Self: LayoutContainable {
    
    func active() -> AnyLayout {
        layouts.forEach({ layout in _ = layout.active() })
        return AnyLayout(nil)
    }
    
    func deactive() {
        layouts.forEach({ layout in layout.deactive() })
    }
    
}

public extension Layout where Self: LayoutAttachable, Self: LayoutContainable, Self: UIViewContainable {
    
    func active() -> AnyLayout {
        layouts.forEach({ layout in
            layout.attachLayout(self)
        })
        return AnyLayout(self)
    }
    
    func attachLayout(_ layout: LayoutAttachable) {
        layout.addSubview(view)
        layouts.forEach({ layout in layout.attachLayout(self) })
    }
    
    func deactive() {
        view.deactive()
        layouts.forEach({ layout in layout.deactive() })
    }
    
}
