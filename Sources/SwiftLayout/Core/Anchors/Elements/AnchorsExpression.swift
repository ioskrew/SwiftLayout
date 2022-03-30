//
//  AnchorsExpression.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit
import _SwiftLayoutUtil

public struct AnchorsExpression<Attribute: AnchorsAttribute> {
    private var attributes: [Attribute]
    private var relation: NSLayoutConstraint.Relation = .equal
    private var toItem: AnchorsItem = .transparent
    private var toAttribute: Attribute? = nil
    
    private var constant: CGFloat = 0.0
    private var multiplier: CGFloat = 1.0
    
    init(
        from anchors: AnchorsExpression<Attribute>,
        relation: NSLayoutConstraint.Relation,
        toItem: AnchorsItem,
        toAttribute: Attribute? = nil,
        constant: CGFloat = 0.0,
        multiplier: CGFloat = 1.0
    ) {
        self.attributes = anchors.attributes
        self.relation = relation
        self.toItem = toItem
        self.toAttribute = toAttribute
        self.constant = constant
        self.multiplier = multiplier
    }
    
    init(from anchors: AnchorsExpression<Attribute>, appendedAttribute: Attribute) {
        self.attributes = anchors.attributes + [appendedAttribute]
        self.relation = anchors.relation
        self.toItem = anchors.toItem
        self.toAttribute = anchors.toAttribute
        self.constant = anchors.constant
        self.multiplier = anchors.multiplier
    }
    
    private func targetFromConstraint(_ constraint: NSLayoutConstraint) -> (toItem: AnchorsItem, toAttribute: Attribute?) {
        if let object = constraint.secondItem as? NSObject {
            return (toItem: .object(object), toAttribute: Attribute(attribute: constraint.secondAttribute))
        } else {
            return (toItem: self.toItem, toAttribute: Attribute(attribute: constraint.secondAttribute))
        }
    }
}

extension AnchorsExpression: AnchorsContainable {
    mutating func setMultiplier(_ multiplier: CGFloat) {
        self.multiplier = multiplier
    }
    
    func nsLayoutConstraint(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView]) -> [NSLayoutConstraint] {
        let to = self.toItem(toItem, viewDic: viewDic)
        assert(to is UIView || to is UILayoutGuide || to == nil, "to: \(to.debugDescription) is not item")
        
        let toAttribute = self.toAttribute?.attribute
        
        return attributes.map { attribute in
            let attribute = attribute.attribute
            let constraint = NSLayoutConstraint(
                item: fromItem,
                attribute: attribute,
                relatedBy: relation,
                toItem: to,
                attribute: toAttribute ?? attribute,
                multiplier: multiplier,
                constant: constant
            )
            constraint.priority = .required
            return constraint
        }
    }
    
    private func toItem(_ toItem: NSObject?, viewDic: [String: UIView]) -> NSObject? {
        switch self.toItem {
        case let .object(object):
            return object
        case let .identifier(identifier):
            return viewDic[identifier] ?? toItem
        case .transparent:
            return toItem
        case .deny:
            if  Attribute.self == AnchorsDimensionAttribute.self {
                return nil
            } else {
                return toItem
            }
        }
    }

    var descriptions: [String] {
        let valuesDescription = valuesDescription()
        return attributes.map {
            var elements = attributeDescription(attribute: $0)
            elements.append(contentsOf: valuesDescription)
            return elements.joined(separator: " ")
        }
    }
    
    private func attributeDescription(attribute: Attribute) -> [String] {
        var elements = Array<String>()
        elements.append(".".appending(attribute.attribute.description))
        elements.append(relation.shortDescription)
        if let itemDescription = toItem.shortDescription {
            if let toAttribute = toAttribute {
                elements.append(itemDescription.appending(".").appending(toAttribute.attribute.description))
            } else {
                elements.append(itemDescription.appending(".").appending(attribute.attribute.description))
            }
        } else if Attribute.self != AnchorsDimensionAttribute.self {
            if let toAttribute = toAttribute {
                elements.append("superview.".appending(toAttribute.attribute.description))
            } else {
                elements.append("superview.".appending(attribute.attribute.description))
            }
        }
        return elements
    }
    
    private func valuesDescription() -> [String] {
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

extension AnchorsExpression {
    
    public func equalToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .equal, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .greaterThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualToSuper(attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self {
        Self.init(from: self, relation: .lessThanOrEqual, toItem: .transparent, toAttribute: attribute, constant: constant)
    }

    public func equalTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: AnchorsItemable {
        Self.init(from: self, relation: .equal, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: AnchorsItemable {
        Self.init(from: self, relation: .greaterThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
    }
    
    public func lessThanOrEqualTo<I>(_ toItem: I, attribute: Attribute? = nil, constant: CGFloat = .zero) -> Self where I: AnchorsItemable {
        Self.init(from: self, relation: .lessThanOrEqual, toItem: AnchorsItem(toItem), toAttribute: attribute, constant: constant)
    }
    
    public func constant(_ constant: CGFloat) -> Self {
        Self.init(from: self, relation: self.relation, toItem: self.toItem, constant: constant)
    }
    
    public func multiplier(_ multiplier: CGFloat) -> Self {
        Self.init(from: self, relation: self.relation, toItem: self.toItem, multiplier: multiplier)
    }
}

extension AnchorsExpression where Attribute == AnchorsXAxisAttribute {
    
    init(xAxis attributes: Attribute...) {
        self.attributes = attributes
    }
    
    public var centerX: Self { Self.init(from: self, appendedAttribute: .centerX) }
    public var leading: Self { Self.init(from: self, appendedAttribute: .leading) }
    public var trailing: Self { Self.init(from: self, appendedAttribute: .trailing) }
    public var left: Self { Self.init(from: self, appendedAttribute: .left) }
    public var right: Self { Self.init(from: self, appendedAttribute: .right) }
    public var centerXWithinMargins: Self { Self.init(from: self, appendedAttribute: .centerXWithinMargins) }
    public var leftMargin: Self { Self.init(from: self, appendedAttribute: .leftMargin) }
    public var rightMargin: Self { Self.init(from: self, appendedAttribute: .rightMargin) }
    public var leadingMargin: Self { Self.init(from: self, appendedAttribute: .leadingMargin) }
    public var trailingMargin: Self { Self.init(from: self, appendedAttribute: .trailingMargin) }

    public func equalTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutXAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().leadingAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}

extension AnchorsExpression where Attribute == AnchorsYAxisAttribute {
    
    init(yAxis attributes: Attribute...) {
        self.attributes = attributes
    }

    public var centerY: Self { Self.init(from: self, appendedAttribute: .centerY) }
    public var top: Self { Self.init(from: self, appendedAttribute: .top) }
    public var bottom: Self { Self.init(from: self, appendedAttribute: .bottom) }
    public var firstBaseline: Self { Self.init(from: self, appendedAttribute: .firstBaseline) }
    public var lastBaseline: Self { Self.init(from: self, appendedAttribute: .lastBaseline) }
    public var centerYWithinMargins: Self { Self.init(from: self, appendedAttribute: .centerYWithinMargins) }
    public var topMargin: Self { Self.init(from: self, appendedAttribute: .topMargin) }
    public var bottomMargin: Self { Self.init(from: self, appendedAttribute: .bottomMargin) }
    
    public func equalTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutYAxisAnchor, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().topAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}

extension AnchorsExpression where Attribute == AnchorsDimensionAttribute {
    
    init(dimensions attributes: Attribute...) {
        self.attributes = attributes
    }

    public func equalTo(constant: CGFloat) -> Self {
        Self.init(from: self, relation: .equal, toItem: .deny, constant: constant)
    }
    
    public var height: Self { Self.init(from: self, appendedAttribute: .height) }
    public var width: Self { Self.init(from: self, appendedAttribute: .width) }
    
    public func equalTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .equal, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func greaterThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .greaterThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
    
    public func lessThanOrEqualTo(_ layoutAnchor: NSLayoutDimension, constant: CGFloat = .zero) -> Self {
        let tmpConstraint = UIView().widthAnchor.constraint(equalTo: layoutAnchor)
        let target = targetFromConstraint(tmpConstraint)
        return Self.init(from: self, relation: .lessThanOrEqual, toItem: target.toItem, toAttribute: target.toAttribute, constant: constant)
    }
}
