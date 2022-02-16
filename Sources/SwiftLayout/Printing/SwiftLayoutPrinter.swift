//
//  SwiftLayoutPrinter.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import Foundation
import UIKit

public struct SwiftLayoutPrinter: CustomStringConvertible {
    public init(view: UIView) {
        self.view = view
    }
    
    let view: UIView
    
    public var description: String {
        print()
    }
    
    public func print() -> String {
        
        func tokens(_ view: UIView) -> ViewToken {
            ViewToken(identifier: view.tagDescription, subtokens: view.subviews.map(tokens))
        }
        
        func constraints(_ view: UIView) -> [ConstraintToken] {
            view.constraints.map(ConstraintToken.init) + view.subviews.flatMap(constraints)
        }
        
        let token = tokens(view)
        token.constraints = constraints(view)
        return token.description
    }
    
    final class ViewToken: CustomStringConvertible {
        internal init(identifier: String, subtokens: [SwiftLayoutPrinter.ViewToken]) {
            self.identifier = identifier
            self.subtokens = subtokens
        }
        
        let identifier: String
        let subtokens: [ViewToken]
        
        var constraints: [ConstraintToken] = [] {
            didSet {
                subtokens.forEach { token in
                    token.constraints = constraints
                }
            }
        }
        
        var selfConstraints: [ConstraintToken]? {
            let constraints = self.constraints.filter({ $0.firstTag == identifier })
            if constraints.isEmpty { return nil }
            return constraints
        }
        
        var description: String {
            var identifiers: [String]
            if subtokens.isEmpty {
                if let selfConstraints = selfConstraints {
                    identifiers = [identifier + ".anchors {"]
                    identifiers.append(contentsOf: selfConstraints.map({ token in
                        "\t" + token.description
                    }))
                    identifiers.append("}")
                } else {
                    identifiers = [identifier]
                }
            } else {
                identifiers = [identifier + " {"]
                identifiers.append(contentsOf: subtokens.map({ token in
                    token.description.split(separator: "\n").map({ "\t" + $0 }).joined(separator: "\n")
                }))
                identifiers.append("}")
            }
            return identifiers.joined(separator: "\n")
        }
    }
    
    final class ConstraintToken: CustomStringConvertible {
        internal init(constraint: NSLayoutConstraint) {
            firstTag = (constraint.firstItem as? UIView)?.tagDescription ?? ""
            firstAttribute = constraint.firstAttribute.description
            secondTag = (constraint.secondItem as? UIView)?.tagDescription ?? ""
            secondAttribute = constraint.secondAttribute.description
            relation = constraint.relation.description
            constant = constraint.constant.description
        }
        
        let firstTag: String
        let firstAttribute: String
        let secondTag: String
        let secondAttribute: String
        let relation: String
        let constant: String
        
        var description: String {
            if secondTag.isEmpty {
                return "Anchors(.\(firstAttribute)).to(.\(relation), to: .init(attribute: .\(secondAttribute), constant: \(constant)))"
            } else {
                return "Anchors(.\(firstAttribute)).to(.\(relation), to: .init(item: \(secondTag), attribute: .\(secondAttribute), constant: \(constant)))"
            }
        }
    }

}
