//
//  Constraint.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit
import _SwiftLayoutUtil

enum Item: Hashable {
    case object(NSObject)
    case identifier(String)
    case transparent
    case deny
    
    init(_ item: Any?) {
        if let string = item as? String {
            self = .identifier(string)
        } else if let object = item as? NSObject {
            self = .object(object)
        } else {
            self = .transparent
        }
    }
    
    var shortDescription: String? {
        switch self {
        case .object(let object):
            if let view = object as? UIView {
                return view.tagDescription
            } else if let guide = object as? UILayoutGuide {
                return guide.propertyDescription
            } else {
                return "unknown"
            }
        case .identifier(let string):
            return string
        case .transparent:
            return "superview"
        case .deny:
            return nil
        }
    }
}

final class Constraint: Hashable, CustomStringConvertible {
    static func == (lhs: Constraint, rhs: Constraint) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal, toItem: Item = .transparent, toAttribute: NSLayoutConstraint.Attribute? = nil, constant: CGFloat = 0.0, multiplier: CGFloat = 1.0) {
        self.attribute = attribute
        self.relation = relation
        self.toItem = toItem
        self.toAttribute = toAttribute
        self.constant = constant
        self.multiplier = multiplier
    }
    
    var attribute: NSLayoutConstraint.Attribute
    var relation: NSLayoutConstraint.Relation = .equal
    var toItem: Item = .transparent
    var toAttribute: NSLayoutConstraint.Attribute?
    
    var constant: CGFloat = 0.0
    var multiplier: CGFloat = 1.0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(attribute)
        hasher.combine(relation)
        hasher.combine(toItem)
        hasher.combine(toAttribute)
        hasher.combine(constant)
        hasher.combine(multiplier)
    }
    
    func toItem(_ toItem: NSObject?, viewDic: [String: UIView]) -> NSObject? {
        switch self.toItem {
        case let .object(object):
            return object
        case let .identifier(identifier):
            return viewDic[identifier] ?? toItem
        case .transparent:
            return toItem
        case .deny:
            switch attribute {
            case .width, .height:
                return nil
            default:
                return toItem
            }
        }
    }
    
    func toAttribute(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint.Attribute {
        return toAttribute ?? attribute
    }
    
    var description: String {
        var elements = attributeDescription()
        elements.append(contentsOf: valuesDescription())
        return elements.joined(separator: " ")
    }
    
    func attributeDescription() -> [String] {
        var elements = Array<String>()
        elements.append(".".appending(attribute.description))
        elements.append(relation.shortDescription)
        if let itemDescription = toItem.shortDescription {
            if let toAttribute = toAttribute {
                elements.append(itemDescription.appending(".").appending(toAttribute.description))
            } else {
                elements.append(itemDescription.appending(".").appending(attribute.description))
            }
        } else if attribute != .height && attribute != .width {
            if let toAttribute = toAttribute {
                elements.append("superview.".appending(toAttribute.description))
            } else {
                elements.append("superview.".appending(attribute.description))
            }
        }
        return elements
    }
    
    func valuesDescription() -> [String] {
        var elements = Array<String>()
        if multiplier != 1.0 {
            elements.append("x ".appending(multiplier.description))
        }

        if constant < 0.0 {
            elements.append("- ".appending(abs(constant).description))
        } else if constant > 0.0 {
            elements.append("+ ".appending(constant.description))
        }
        return elements
    }
}
