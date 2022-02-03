//
//  TupleLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public struct TupleLayout<Tuple>: LayoutAttachable, LayoutContainable {
    
    let tuple: Tuple
    
    public var layouts: [LayoutAttachable] { castArrayFromTuple() }
    
    public func deactive() {}
    
    func castArrayFromTuple() -> [LayoutAttachable] {
        if let tuple = tuple as? (LayoutAttachable, LayoutAttachable, LayoutAttachable) {
            return [tuple.0, tuple.1, tuple.2]
        } else if let tuple = tuple as? (LayoutAttachable, LayoutAttachable, LayoutAttachable, LayoutAttachable) {
            return [tuple.0, tuple.1, tuple.2, tuple.3]
        } else if let tuple = tuple as? (LayoutAttachable, LayoutAttachable, LayoutAttachable, LayoutAttachable, LayoutAttachable) {
            return [tuple.0, tuple.1, tuple.2, tuple.3, tuple.4]
        } else {
            return []
        }
    }
    
    public func attachConstraint(_ constraint: LayoutConstraintAttachable) {
        layouts.forEach { layout in
            layout.attachConstraint(constraint)
        }
    }
}
