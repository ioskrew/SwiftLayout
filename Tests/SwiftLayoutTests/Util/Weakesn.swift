//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/02/21.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct Weakens<O>: Hashable where O: Hashable {
    let hashable: AnyHashable
    
    init(_ o: O, handler: (O) -> AnyHashable) {
        self.hashable = handler(o)
    }
}

extension Weakens where O == NSLayoutConstraint {
    init(_ constraint: O) {
        self.init(constraint) { constraint in
            var hashables: Set<AnyHashable> = []
            hashables.insert(AnyHashable(constraint.firstItem as? NSObject))
            hashables.insert(AnyHashable(constraint.firstAttribute))
            hashables.insert(AnyHashable(constraint.secondItem as? NSObject))
            hashables.insert(AnyHashable(constraint.secondAttribute))
            hashables.insert(AnyHashable(constraint.relation))
            hashables.insert(AnyHashable(constraint.constant))
            hashables.insert(AnyHashable(constraint.multiplier))
            return AnyHashable(Set(hashables))
        }
    }
}

extension Weakens where O == Array<NSLayoutConstraint> {
    init(_ constraints: O) {
        self.init(constraints) { constraints in
            let weakens: [Weakens<NSLayoutConstraint>] = constraints.map { constraint in
                Weakens<NSLayoutConstraint>(constraint)
            }
            return AnyHashable(Set(weakens))
        }
    }
}
