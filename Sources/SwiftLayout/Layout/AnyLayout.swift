//
//  AnyLayoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

final public class AnyLayout: Hashable, Layout {
    
    public static func == (lhs: AnyLayout, rhs: AnyLayout) -> Bool {
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
    
    public func active() -> AnyLayout {
        layoutable?.active()
        return self
    }
    
    public func deactive() {
        layoutable?.deactive()
    }
    
    public var equation: AnyHashable {
        AnyHashable(layoutable?.equation)
    }
}
