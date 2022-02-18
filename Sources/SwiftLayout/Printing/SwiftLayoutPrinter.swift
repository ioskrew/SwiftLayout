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
    
    public func print(_ options: LayoutOptions = []) -> String {
        
        func tokens(_ view: UIView, tags: [String: String]) -> ViewToken {
            ViewToken(identifier: tags[view.tagDescription] ?? view.tagDescription, subtokens: view.subviews.map({ tokens($0, tags: tags) }))
        }
        
        func constraints(_ view: UIView, tags: [String: String]) -> [ConstraintToken] {
            view.constraints.compactMap({ ConstraintToken(constraint: $0, tags: tags) }) + view.subviews.flatMap({ constraints($0, tags:tags) })
        }
        
        guard let view = view else {
            return ""
        }
        
        if options.contains(.accessibilityIdentifiers) {
            IdentifierUpdater(view).update()
        }

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
                    identifiers.append(ConstraintTokenGroup(selfConstraints).description)
                    identifiers.append("}")
                } else {
                    identifiers = [identifier]
                }
            } else {
                if selfConstraints == nil {
                    identifiers = [identifier + " {"]
                } else if let selfConstraints = selfConstraints {
                    identifiers = [identifier + ".anchors {"]
                    identifiers.append(ConstraintTokenGroup(selfConstraints).description)
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
    
    final class ConstraintTokenGroup: CustomStringConvertible {
        let tokens: [ConstraintToken]
        init(_ tokens: [ConstraintToken]) {
            self.tokens = tokens
        }
        
        var description: String {
            var mergedTokens: [ConstraintToken] = []
            for token in tokens {
                if mergedTokens.isEmpty {
                    mergedTokens.append(token)
                } else {
                    func intersect(_ rhs: ConstraintToken) -> (ConstraintToken) -> Bool {
                        { lhs in
                            lhs.firstTag == rhs.firstTag
                            && lhs.secondTag == rhs.secondTag
                            && lhs.constant == rhs.constant
                            && lhs.relation == rhs.relation
                        }
                    }
                    if let groupToken = mergedTokens.first(where: intersect(token)) {
                        groupToken.firstAttributes.append(token.firstAttribute)
                    } else {
                        mergedTokens.append(token)
                    }
                }
            }
            
            return mergedTokens.map({ "\t" + $0.description }).joined(separator: "\n")
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
            func superTagFromItem(_ item: AnyObject?) -> String {
                if let view = (item as? UIView)?.superview {
                    return tagFromItem(view)
                } else if let view = (item as? UILayoutGuide)?.owningView?.superview {
                    return tagFromItem(view)
                } else {
                    return tagFromItem(item)
                }
            }
            func isSystemConstraint(_ constraint: NSLayoutConstraint) -> Bool {
                let description = constraint.debugDescription
                guard let range = description.range(of: "'UIViewSafeAreaLayoutGuide-[:alpha:]*'", options: [.regularExpression], range: description.startIndex..<description.endIndex) else { return false }
                return !range.isEmpty
            }
            guard !isSystemConstraint(constraint) else { return nil }
            superTag = superTagFromItem(constraint.firstItem)
            firstTag = tagFromItem(constraint.firstItem)
            firstAttribute = constraint.firstAttribute.description
            firstAttributes = [firstAttribute]
            secondTag = tagFromItem(constraint.secondItem)
            secondAttribute = constraint.secondAttribute.description
            relation = constraint.relation.description
            constant = constraint.constant.description
        }
        
        let superTag: String
        let firstTag: String
        let firstAttribute: String
        var firstAttributes: [String]
        let secondTag: String
        let secondAttribute: String
        let relation: String
        let constant: String
        
        var description: String {
            var descriptions: [String] = ["Anchors(\(firstAttributes.map({ "." + $0 }).joined(separator: ", ")))"]
            var arguments: [String] = []
            if !secondTag.isEmpty && superTag != secondTag {
                arguments.append(secondTag)
            }
            if firstAttribute != secondAttribute && secondAttribute != NSLayoutConstraint.Attribute.notAnAttribute.description {
                arguments.append("attribute: .\(secondAttribute)")
            }
            if constant != "0.0" {
                arguments.append("constant: \(constant)")
            }
            if !arguments.isEmpty {
                descriptions.append("\(relation)To(\(arguments.joined(separator: ", ")))")
            }
            return descriptions.joined(separator: ".")
        }
        
        private func functionNameByRelation(_ relation: NSLayoutConstraint.Relation) -> String {
            relation.description
        }
        
    }

}
