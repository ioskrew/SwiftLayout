//
//  LayoutRule.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

extension SwiftLayout {
    
    struct Rule: Hashable, CustomDebugStringConvertible {
        internal init(relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0) {
            self.relation = relation
            self.multiplier = multiplier
            self.constant = constant
        }
        
        let relation: NSLayoutConstraint.Relation
        
        var multiplier: CGFloat = 1.0
        var constant: CGFloat = 0.0
        
        func bind(first: Element, second: Element) -> Binding {
            Binding(first: first, second: second, rule: self)
        }
        
        public var debugDescription: String {
            return "\(relation)(\(constant < 0.0 ? "-" : "+")\(constant) x \(multiplier))"
        }
        
        static var equal: Self {
            Rule()
        }
    }
   
}
