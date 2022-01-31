//
//  AnyLayoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

final public class AnyLayoutable: Hashable, Layout {
    
    public static func == (lhs: AnyLayoutable, rhs: AnyLayoutable) -> Bool {
        lhs.layoutable?.equation == rhs.layoutable?.equation
    }
    
    internal init(_ layoutable: Layout?) {
        self.layoutable = layoutable
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(layoutable?.equation)
    }
    
    var layoutable: Layout?
    
    deinit {
        layoutable?.deactive()
        layoutable = nil
    }
    
    public func active() -> AnyLayoutable {
        layoutable?.active()
        return self
    }
    
    public func deactive() {
        layoutable?.deactive()
    }
    
    public func layoutTree(in parent: UIView) -> LayoutTree {
        layoutable?.layoutTree(in: parent) ?? LayoutTree(view: parent)
    }
    
    public var equation: AnyHashable {
        AnyHashable(layoutable?.equation)
    }
}
