//
//  SwiftLayoutPrinter.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import Foundation
import UIKit

public struct SwiftLayoutPrinter {
    public init(view: UIView) {
        self.view = view
    }
    
    let view: UIView
    
    public func print() -> String {
        
        func tokens(_ view: UIView) -> ViewToken {
            ViewToken(identifier: view.tagDescription, subtokens: view.subviews.map(tokens))
        }
        
        func constraints(_ view: UIView) -> [ConstraintToken] {
            view.constraints.map(ConstraintToken.init) + view.subviews.flatMap(constraints)
        }
        
        let token = tokens(view)
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
        
        var description: String {
            var identifiers: [String]
            if subtokens.isEmpty {
                identifiers = [identifier]
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
    
    final class ConstraintToken {
        internal init(constraint: NSLayoutConstraint) {
            self.constraint = constraint
        }
        
        let constraint: NSLayoutConstraint
    }

}
