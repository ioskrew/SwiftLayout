//
//  LayoutBinding.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

public extension SwiftLayout {
    
    ///
    /// Binding
    struct Binding: Hashable, CustomDebugStringConvertible {
        
        /// Binding 생성자
        /// - Parameters:
        ///   - first: layout constraint의 첫번째 item
        ///   - second: layout constraint의 두번째 item
        ///   - rule: 각 item의 결합 규칙
        internal init(first: SwiftLayout.Element, second: SwiftLayout.Element?, rule: SwiftLayout.Rule = Rule.equal) {
            self.first = first
            self.second = second
            self.rule = rule
        }
        
        let first: SwiftLayout.Element
        let second: SwiftLayout.Element?
        let rule: SwiftLayout.Rule
        
        func bind() -> NSLayoutConstraint {
            first.view?.translatesAutoresizingMaskIntoConstraints = false
            let constraint = NSLayoutConstraint(item: first.view!,
                                                attribute: first.attribute,
                                                relatedBy: rule.relation,
                                                toItem: second?.view,
                                                attribute: second?.attribute ?? .notAnAttribute,
                                                multiplier: rule.multiplier,
                                                constant: rule.constant)
            return constraint
        }
        
        public var debugDescription: String {
            var descriptions: [String] = []
            descriptions.append("\(first)")
            descriptions.append(rule.debugDescription)
            if let second = second {
                descriptions.append("\(second)")
            }
            return descriptions.joined(separator: " ").trimmingCharacters(in: .whitespaces)
        }
    }
    
}
