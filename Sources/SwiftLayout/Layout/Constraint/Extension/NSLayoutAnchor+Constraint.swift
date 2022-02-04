//
//  ConstraintAssistant.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

extension LayoutConstraintAttachable {
    public func active() -> AnyDeactivatable {
        AnyDeactivatable()
    }
}

extension NSLayoutAnchor: LayoutConstraintAttachable {}

extension LayoutConstraintAttachable where Self: NSObject {
    
    var item: Any? {
        self.value(forKey: "item")
    }
    
    public var guide: UILayoutGuide? {
        if item is UILayoutGuide {
            return item as? UILayoutGuide
        } else {
            return nil
        }
    }
    
    public var view: UIView? {
        if item is UIView {
            return item as? UIView
        } else {
            return nil
        }
    }
    
    var attribute: NSLayoutConstraint.Attribute {
        if let view = view {
            return view.attribute(self)
        } else if let guide = self.guide {
            return guide.attribute(self)
        } else {
            return .notAnAttribute
        }
    }
  
    var anchorType: LayoutAnchorType {
        .init(self)
    }
    
    public func constraints(with view: UIView) -> NSLayoutConstraint? {
        switch attribute {
        case .top:
            return anchorType.equal(with: view.topAnchor.anchorType)
        default:
            return nil
        }
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        if let view = view {
            layout.addSubview(view)
        } else if let view = guide?.owningView {
            layout.addSubview(view)
        }
    }
    
    public func deactive() {
        
    }
    
    public var hashable: AnyHashable {
        AnyHashable(self)
    }
}

extension NSLayoutConstraint.Attribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .left:
            return "NSLayoutConstraint.Attribute.left"
        case .right:
            return "NSLayoutConstraint.Attribute.right"
        case .top:
            return "NSLayoutConstraint.Attribute.top"
        case .bottom:
            return "NSLayoutConstraint.Attribute.bottom"
        case .leading:
            return "NSLayoutConstraint.Attribute.leading"
        case .trailing:
            return "NSLayoutConstraint.Attribute.trailing"
        case .width:
            return "NSLayoutConstraint.Attribute.width"
        case .height:
            return "NSLayoutConstraint.Attribute.height"
        case .centerX:
            return "NSLayoutConstraint.Attribute.centerX"
        case .centerY:
            return "NSLayoutConstraint.Attribute.centerY"
        case .lastBaseline:
            return "NSLayoutConstraint.Attribute.lastBaseline"
        case .firstBaseline:
            return "NSLayoutConstraint.Attribute.firstBaseline"
        case .leftMargin:
            return "NSLayoutConstraint.Attribute.leftMargin"
        case .rightMargin:
            return "NSLayoutConstraint.Attribute.rightMargin"
        case .topMargin:
            return "NSLayoutConstraint.Attribute.topMargin"
        case .bottomMargin:
            return "NSLayoutConstraint.Attribute.bottomMargin"
        case .leadingMargin:
            return "NSLayoutConstraint.Attribute.leadingMargin"
        case .trailingMargin:
            return "NSLayoutConstraint.Attribute.trailingMargin"
        case .centerXWithinMargins:
            return "NSLayoutConstraint.Attribute.centerXWithinMargins"
        case .centerYWithinMargins:
            return "NSLayoutConstraint.Attribute.centerYWithinMargins"
        case .notAnAttribute:
            return "NSLayoutConstraint.Attribute.notAnAttribute"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}

extension NSLayoutConstraint.Relation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .lessThanOrEqual:
            return "NSLayoutConstraint.Attribute.lessThanOrEqual"
        case .equal:
            return "NSLayoutConstraint.Attribute.equal"
        case .greaterThanOrEqual:
            return "NSLayoutConstraint.Attribute.greaterThanOrEqual"
        @unknown default:
            return "NSLayoutConstraint.Attribute.unknown"
        }
    }
}

protocol LayoutAnchorTypeInterface {
    var anchorType: LayoutAnchorType { get }
}

extension LayoutAnchorTypeInterface where Self: LayoutConstraintAttachable, Self: NSObject {
    var anchorType: LayoutAnchorType {
        LayoutAnchorType(self)
    }
}

extension NSLayoutAnchor: LayoutAnchorTypeInterface {}

enum LayoutAnchorType: LayoutAnchorTypeInterface {
    case x(NSLayoutXAxisAnchor)
    case y(NSLayoutYAxisAnchor)
    case size(NSLayoutDimension)
    case idontknow
    
    init(_ anchor: AnyObject?) {
        if let x = anchor as? NSLayoutXAxisAnchor {
            self = .x(x)
        } else if let y = anchor as? NSLayoutYAxisAnchor {
            self = .y(y)
        } else if let size = anchor as? NSLayoutDimension {
            self = .size(size)
        } else {
            self = .idontknow
        }
    }
    
    var anchorType: LayoutAnchorType { self }
    
    func relation<Anchor, AnchorType>(first: Anchor, relation: NSLayoutConstraint.Relation) -> (Anchor, CGFloat) -> NSLayoutConstraint where Anchor: NSLayoutAnchor<AnchorType> {
        switch relation {
        case .equal:
            return first.constraint(equalTo:constant:)
        case .greaterThanOrEqual:
            return first.constraint(greaterThanOrEqualTo:constant:)
        case .lessThanOrEqual:
            return first.constraint(lessThanOrEqualTo:constant:)
        @unknown default:
            return first.constraint(equalTo:constant:)
        }
    }
    
    func constraint<A: LayoutAnchorTypeInterface>(to second: A?, relation: NSLayoutConstraint.Relation, constant: CGFloat) -> NSLayoutConstraint? {
        switch (self, second?.anchorType) {
        case let (.x(first), .x(second)):
            return self.relation(first: first, relation: relation)(second, constant)
        case let (.y(first), .y(second)):
            return self.relation(first: first, relation: relation)(second, constant)
        case let (.size(first), .size(second)):
            return self.relation(first: first, relation: relation)(second, constant)
        default:
            return nil
        }
    }
    
    func equal<A: LayoutAnchorTypeInterface>(with second: A, constant: CGFloat = CGFloat.zero) -> NSLayoutConstraint? {
        constraint(to: second, relation: .equal, constant: constant)
    }
    
}
