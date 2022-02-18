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
        
        guard let view = view else {
            return ""
        }
        
        if options.contains(.accessibilityIdentifiers) {
            IdentifierUpdater(view).update()
        }

        let viewToken = ViewToken.Parser.from(view, tags: tags)
        let constraints = ConstraintToken.Parser.from(view, tags: tags)
        return Describer(viewToken, constraints).description
    }
    
    struct Describer: CustomStringConvertible {
        
        init(_ token: ViewToken, _ constraints: [ConstraintToken]) {
            self.views = token.views
            self.constraints = constraints
            self.identifier = token.identifier
        }
        
        var description: String {
            if views.isEmpty {
                return fromConstraints(constraintsOfIdentifier, identifier: identifier).joined(separator: "\n")
            } else {
                return fromViews(constraintsOfIdentifier, views: views, identifier: identifier).joined(separator: "\n")
            }
        }
        
        private var constraintsOfIdentifier: [ConstraintToken]? {
            let constraints = constraints.filter({ $0.firstTag == identifier })
            if constraints.isEmpty { return nil }
            return constraints
        }
        
        private let views: [ViewToken]
        private let constraints: [ConstraintToken]
        private let identifier: String
        
        private func fromConstraints(_ constraints: [ConstraintToken]?, identifier: String) -> [String] {
            guard  let constraintTokens = constraints else { return [identifier] }
            var identifiers = [identifier + ".anchors {"]
            identifiers.append(ConstraintTokenGroup(constraintTokens).description)
            identifiers.append("}")
            return identifiers
        }
        
        private func fromViews(_ constraints: [ConstraintToken]?, views: [ViewToken], identifier: String) -> [String] {
            var identifiers: [String] = []
            if constraints == nil {
                identifiers = [identifier + " {"]
            } else if let selfConstraints = constraints {
                identifiers = [identifier + ".anchors {"]
                identifiers.append(ConstraintTokenGroup(selfConstraints).description)
                identifiers.append("}.subviews {")
            } else {
                identifiers = [identifier + " {"]
            }
            identifiers.append(contentsOf: views.map({ view in
                let description = Describer(view, self.constraints).description
                return description.split(separator: "\n").map({ "\t" + $0 }).joined(separator: "\n")
            }))
            identifiers.append("}")
            return identifiers
        }
        
    }
    
    final class ViewToken {
        
        private init(identifier: String, views: [ViewToken]) {
            self.identifier = identifier
            self.views = views
        }
        
        let identifier: String
        let views: [ViewToken]
        
        struct Parser {
            static func from(_ view: UIView, tags: [String: String]) -> ViewToken {
                if let identifier = tags[view.tagDescription] {
                    return ViewToken(identifier: identifier, views: view.subviews.map({ from($0, tags: tags) }))
                } else {
                    return ViewToken(identifier: view.tagDescription, views: view.subviews.map({ from($0, tags: tags) }))
                }
            }
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
        
        struct Parser {
            static func from(_ view: UIView, tags: [String: String]) -> [ConstraintToken] {
                view.constraints.compactMap({ ConstraintToken(constraint: $0, tags: tags) }) + view.subviews.flatMap({ from($0, tags:tags) })
            }
        }
        
        private init?(constraint: NSLayoutConstraint, tags: [String: String]) {
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
