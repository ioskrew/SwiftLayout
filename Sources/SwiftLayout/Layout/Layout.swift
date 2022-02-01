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
    func reactive()
    func deactive()
    func deactiveRoot()
    
    var hashable: AnyHashable { get }
    
    var tagDescription: String { get }
}

extension Layout {
    public var tagDescription: String { "" }
}

extension Layout {
    public func reactive() {}
    public func deactiveRoot() {
        deactive()
    }
}

public extension Layout where Self: LayoutContainable {
    
    func active() -> AnyDeactivatable {
        layouts.forEach({ layout in _ = layout.active() })
        return AnyDeactivatable()
    }
    
    func deactive() {
        layouts.forEach({ layout in layout.deactive() })
    }
    
    var hashable: AnyHashable {
        AnyHashable([typeString(of: self)] + layouts.map(\.hashable))
    }
    
}

public extension LayoutAttachable where Self: LayoutContainable, Self: UIViewContainable {
    
    func active() -> AnyDeactivatable {
        reactive()
        return AnyDeactivatable(self)
    }
    
    func reactive() {
        layouts.forEach({ layout in
            layout.attachLayout(self)
        })
    }
    
    func attachLayout(_ layout: LayoutAttachable) {
        layout.addSubview(view)
        layouts.forEach({ layout in layout.attachLayout(self) })
    }
    
    func deactive() {
        view.deactive()
        layouts.forEach({ layout in layout.deactive() })
    }
    
    func deactiveRoot() {
        layouts.forEach({ layout in layout.deactive() })
    }
    
    var hashable: AnyHashable {
        AnyHashable([typeString(of: self)] + [view] + layouts.map(\.hashable))
    }
}
