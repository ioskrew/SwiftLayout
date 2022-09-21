//
//  ConstraintToken.swift
//  
//
//  Created by oozoofrog on 2022/03/28.
//

import Foundation
import UIKit

struct AnchorToken: Hashable {
    static func == (lhs: AnchorToken, rhs: AnchorToken) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    static func < (lhs: AnchorToken, rhs: AnchorToken) -> Bool {
        [

        ].allSatisfy({ $0 })
    }
    
    private init(constraint: NSLayoutConstraint, tags: ViewTags) {
        let tagger = Tagger(tags: tags)
        superTag = tagger.superTagFromItem(constraint.firstItem)
        firstTag = tagger.tagFromItem(constraint.firstItem)
        firstAttribute = constraint.firstAttribute
        secondTag = tagger.tagFromItem(constraint.secondItem)
        secondAttribute = constraint.secondAttribute
        relation = constraint.relation
        constant = constraint.constant
        multiplier = constraint.multiplier
    }
    
    let superTag: String
    let firstTag: String
    let firstAttribute: NSLayoutConstraint.Attribute
    let secondTag: String
    let secondAttribute: NSLayoutConstraint.Attribute
    let relation: NSLayoutConstraint.Relation
    let constant: CGFloat
    let multiplier: CGFloat
    
    var firstAttributeIsSecondAttribute: Bool {
        if firstAttributeType == .dimension, secondAttribute == .notAnAttribute {
            return true
        } else {
            return firstAttribute == secondAttribute
        }
    }
    
    var secondTagIsSuperview: Bool {
        secondTag == superTag
    }
    
    var firstAttributeType: AttributeType {
        AttributeType(firstAttribute)
    }
    
    enum Parser {
        static func from(_ view: UIView, viewTags tags: ViewTags, options: ViewPrinter.PrintOptions) -> [AnchorToken] {
            let constraints = view.constraints.sorted { lhs, rhs in
                func compareTuple(_ value: NSLayoutConstraint) -> (Int, Int, Int, CGFloat, CGFloat, Float) {
                    (
                        value.firstAttribute.rawValue,
                        value.secondAttribute.rawValue,
                        value.relation.rawValue,
                        value.constant,
                        value.multiplier,
                        value.priority.rawValue
                    )
                }
                
                return compareTuple(lhs) < compareTuple(rhs)
            }.filter({ Validator.isUserCreation($0, options: options) })
            var tokens = constraints.map({ AnchorToken(constraint: $0, tags: tags) })
            tokens.append(contentsOf: view.subviews.flatMap({ from($0, viewTags: tags, options: options) }))
            return tokens
        }
    }
    
    enum Validator {
        static func isUserCreation(_ constraint: NSLayoutConstraint, options: ViewPrinter.PrintOptions) -> Bool {
            let description = constraint.debugDescription
            if options.contains(.withSystemConstraints) {
                return true
            } else {
                guard description.contains("NSLayoutConstraint") else { return false }
                guard let range = description.range(of: "'UIViewSafeAreaLayoutGuide-[:alpha:]*'", options: [.regularExpression], range: description.startIndex..<description.endIndex) else { return true }
                return range.isEmpty
            }
        }
    }
    
    struct Tagger {
        let tags: ViewTags
        func tagFromItem(_ item: AnyObject?) -> String {
            if let view = item as? UIView {
                return tags.tag(object: view) ?? view.tagDescription
            } else if let view = (item as? UILayoutGuide)?.owningView {
                return tags.tag(object: view).flatMap({ $0 + ".safeAreaLayoutGuide" }) ?? (view.tagDescription + ".safeAreaLayoutGuide")
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
    }
    
    enum AttributeType: Equatable {
        case xAxis
        case yAxis
        case dimension
        case unknown
        
        init(_ attribute: NSLayoutConstraint.Attribute) {
            switch attribute {
            case .centerX, .centerXWithinMargins, .leading, .leadingMargin, .trailing, .trailingMargin, .left, .leftMargin, .right, .rightMargin:
                self = .xAxis
            case .centerY, .centerYWithinMargins, .top, .topMargin, .bottom, .bottomMargin, .firstBaseline, .lastBaseline:
                self = .yAxis
            case .width, .height:
                self = .dimension
            default:
                self = .unknown
            }
        }
    }
}
