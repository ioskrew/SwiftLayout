//
//  SwiftLayoutPrinter.swift
//  
//
//  Created by oozoofrog on 2022/02/16.
//

import Foundation
import UIKit

public struct SwiftLayoutPrinter: CustomStringConvertible {
    public init(_ view: UIView, tags: [UIView: String] = [:]) {
        self.view = view
        self.tags = Dictionary(uniqueKeysWithValues: tags.map({ ($0.key.tagDescription, $0.value) }))
    }
    
    weak var view: UIView?
    let tags: [String: String]
    
    public var description: String {
        print()
    }
    
    public func print() -> String {
        
        func tokens(_ view: UIView, tags: [String: String]) -> ViewToken {
            ViewToken(identifier: tags[view.tagDescription] ?? view.tagDescription, subtokens: view.subviews.map({ tokens($0, tags: tags) }))
        }
        
        func constraints(_ view: UIView, tags: [String: String]) -> [ConstraintToken] {
            view.constraints.compactMap({ ConstraintToken(constraint: $0, tags: tags) }) + view.subviews.flatMap({ constraints($0, tags:tags) })
        }
        
        guard let view = view else {
            return ""
        }
        
        let objectIdentifier = ObjectIdentifiers(view)
        objectIdentifier.prepare()

        let token = tokens(view, tags: tags)
        let constraints = constraints(view, tags: tags)
        token.constraints = constraints
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
                if selfConstraints == nil {
                    identifiers = [identifier + " {"]
                } else if let selfConstraints = selfConstraints {
                    identifiers = [identifier + ".anchors {"]
                    identifiers.append(contentsOf: selfConstraints.map({ token in
                        "\t" + token.description
                    }))
                    identifiers.append("}.subviews {")
                } else {
                    identifiers = [identifier + " {"]
                }
                identifiers.append(contentsOf: subtokens.map({ token in
                    token.description.split(separator: "\n").map({ "\t" + $0 }).joined(separator: "\n")
                }))
                identifiers.append("}")
            }
            return identifiers.joined(separator: "\n")
        }
    }
    
    final class ConstraintToken: CustomStringConvertible {
        internal init?(constraint: NSLayoutConstraint, tags: [String: String]) {
            func tagFromItem(_ item: AnyObject?) -> String {
                if let view = item as? UIView {
                    return tags[view.tagDescription] ?? view.tagDescription
                } else if let view = (item as? UILayoutGuide)?.owningView {
                    return tags[view.tagDescription].flatMap({ $0 + ".safeAreaLayoutGuide" }) ?? (view.tagDescription + ".safeAreaLayoutGuide")
                } else {
                    return ""
                }
            }
            func isSystemConstraint(_ constraint: NSLayoutConstraint) -> Bool {
                let description = constraint.debugDescription
                guard let range = description.range(of: "'UIViewSafeAreaLayoutGuide-[:alpha:]*'", options: [.regularExpression], range: description.startIndex..<description.endIndex) else { return false }
                return !range.isEmpty
            }
            guard !isSystemConstraint(constraint) else { return nil }
            firstTag = tagFromItem(constraint.firstItem)
            firstAttribute = constraint.firstAttribute.description
            secondTag = tagFromItem(constraint.secondItem)
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
