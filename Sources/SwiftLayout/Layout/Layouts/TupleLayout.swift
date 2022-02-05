//
//  TupleLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public final class TupleLayout<Tuple>: LayoutAttachable, LayoutContainable {
    
    internal init(tuple: Tuple, constraints: Set<NSLayoutConstraint> = []) {
        self.tuple = tuple
        self.constraints = constraints
    }
    
    let tuple: Tuple
    
    public var layouts: [LayoutAttachable] { castArrayFromTuple() }
    public var constraints: Set<NSLayoutConstraint> = []
    
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
    
    public func setConstraint(_ constraints: [NSLayoutConstraint]) {
        self.constraints = Set(constraints)
    }
}
