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
        let token = view.token
        return token.description
    }
    
    final class ViewToken: CustomStringConvertible {
        internal init(identifier: String, subtokens: [SwiftLayoutPrinter.ViewToken]) {
            self.identifier = identifier
            self.subtokens = subtokens
        }
        
        let identifier: String
        let subtokens: [ViewToken]
        
        var description: String {
            var identifiers: [String]
            if subtokens.isEmpty {
                identifiers = [identifier]
            } else {
                identifiers = [identifier + " {"]
                identifiers.append(contentsOf: subtokens.map({ token in
                    "\t" + token.description
                }))
                identifiers.append("}")
            }
            return identifiers.joined(separator: "\n")
        }
    }

}

fileprivate extension UIView {
    var token: SwiftLayoutPrinter.ViewToken {
        SwiftLayoutPrinter.ViewToken(identifier: tagDescription, subtokens: subviews.map(\.token))
    }
}
