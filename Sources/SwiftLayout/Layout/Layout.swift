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
    func active() -> AnyDeactivatable
    func deactive()
    
    var equation: AnyHashable { get }
}

public extension Layout where Self: LayoutContainable {
    
    func active() -> AnyDeactivatable {
        layouts.forEach({ layout in _ = layout.active() })
        return AnyDeactivatable()
    }
    
    func deactive() {
        layouts.forEach({ layout in layout.deactive() })
    }
    
}

public extension Layout where Self: LayoutAttachable, Self: LayoutContainable, Self: UIViewContainable {
    
    func active() -> AnyDeactivatable {
        layouts.forEach({ layout in
            layout.attachLayout(self)
        })
        return AnyDeactivatable(self)
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
