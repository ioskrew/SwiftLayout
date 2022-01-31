//
//  AnyLayoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

final public class AnyLayout: Hashable, AttachableLayout {
    
    public static func == (lhs: AnyLayout, rhs: AnyLayout) -> Bool {
        lhs.layout?.equation == rhs.layout?.equation
    }
    
    internal init(_ layoutable: AttachableLayout?) {
        self.layout = layoutable
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(layout?.equation)
    }
    
    public var layout: AttachableLayout?
    
    deinit {
        layout?.deactive()
        layout = nil
    }
    
    public func active() -> AnyLayout {
        layout?.active()
        return self
    }
    
    public func deactive() {
        layout?.deactive()
    }
    
    public func attachLayout(_ layout: AttachableLayout) {
        self.layout?.attachLayout(layout)
    }
    
    public var equation: AnyHashable {
        AnyHashable(layout?.equation)
    }
}
