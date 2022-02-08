//
//  NSLayoutAnchor+AnchorType.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol AnchorTypeInterface {
    var anchorType: AnyAnchor { get }
}

extension AnchorTypeInterface where Self: NSObject {
    public var anchorType: AnyAnchor {
        AnyAnchor(self)
    }
}

public enum AnyAnchor: AnchorTypeInterface, Hashable {
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
    
    var item: NSObject? {
        switch self {
        case .x(let nSLayoutXAxisAnchor):
            return nSLayoutXAxisAnchor.value(forKey: "item") as? NSObject
        case .y(let nSLayoutYAxisAnchor):
            return nSLayoutYAxisAnchor.value(forKey: "item") as? NSObject
        case .size(let nSLayoutDimension):
            return nSLayoutDimension.value(forKey: "item") as? NSObject
        case .idontknow:
            return nil
        }
    }
    
    var view: UIView? {
        guard item is UIView else { return nil }
        return item as? UIView
    }
    
    var layoutGuide: UILayoutGuide? {
        guard item is UILayoutGuide else { return nil }
        return item as? UILayoutGuide
    }
    
    var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .x(let nSLayoutXAxisAnchor):
            if let view = view {
                return view.attribute(nSLayoutXAxisAnchor)
            } else if let layoutGuide = layoutGuide {
                return layoutGuide.attribute(nSLayoutXAxisAnchor)
            } else {
                return .notAnAttribute
            }
        case .y(let nSLayoutYAxisAnchor):
            if let view = view {
                return view.attribute(nSLayoutYAxisAnchor)
            } else if let layoutGuide = layoutGuide {
                return layoutGuide.attribute(nSLayoutYAxisAnchor)
            } else {
                return .notAnAttribute
            }
        case .size(let nSLayoutDimension):
            if let view = view {
                return view.attribute(nSLayoutDimension)
            } else if let layoutGuide = layoutGuide {
                return layoutGuide.attribute(nSLayoutDimension)
            } else {
                return .notAnAttribute
            }
        case .idontknow:
            return .notAnAttribute
        }
    }
    
    public var anchorType: AnyAnchor { self }
    
    func relation<Anchor, AnchorType>(first: Anchor, relation: NSLayoutConstraint.Relation, second: Anchor, constant: CGFloat) -> NSLayoutConstraint where Anchor: NSLayoutAnchor<AnchorType> {
        switch relation {
        case .equal:
            return first.constraint(equalTo: second, constant: constant)
        case .greaterThanOrEqual:
            return first.constraint(greaterThanOrEqualTo: second, constant: constant)
        case .lessThanOrEqual:
            return first.constraint(lessThanOrEqualTo: second, constant:constant)
        @unknown default:
            return first.constraint(equalTo: second, constant: constant)
        }
    }
    
    func relation(first: NSLayoutDimension, relation: NSLayoutConstraint.Relation, second: NSLayoutDimension? = nil, constant: CGFloat) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            if let second = second {
                return first.constraint(equalTo: second, constant: constant)
            } else {
                return first.constraint(equalToConstant: constant)
            }
        case .greaterThanOrEqual:
            if let second = second {
                return first.constraint(greaterThanOrEqualTo: second, constant: constant)
            } else {
                return first.constraint(greaterThanOrEqualToConstant: constant)
            }
        case .lessThanOrEqual:
            if let second = second {
                return first.constraint(lessThanOrEqualTo: second, constant: constant)
            } else {
                return first.constraint(lessThanOrEqualToConstant: constant)
            }
        @unknown default:
            if let second = second {
                return first.constraint(equalTo: second, constant: constant)
            } else {
                return first.constraint(equalToConstant: constant)
            }
        }
    }
    
    func constraint(to item: AnchorItem, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero) -> NSLayoutConstraint? {
        switch (self, item.anchor(for: attribute)) {
        case let (.x(first), .x(second)):
            return self.relation(first: first, relation: relation, second: second, constant: constant)
        case let (.y(first), .y(second)):
            return self.relation(first: first, relation: relation, second: second, constant: constant)
        case let (.size(first), .size(second)):
            return self.relation(first: first, relation: relation, second: second, constant: constant)
        default:
            return nil
        }
    }
    
    func constraint(to item: NSObject, relation: NSLayoutConstraint.Relation = .equal, constant: CGFloat = .zero) -> NSLayoutConstraint? {
        self.constraint(to: AnchorItem(item), relation: relation, constant: constant)
    }
    
    enum AnchorItem {
        case none
        case view(UIView)
        case layoutGuide(UILayoutGuide)
        
        init(_ object: NSObject) {
            if let view = object as? UIView {
                self = .view(view)
            } else if let layoutGuide = object as? UILayoutGuide {
                self = .layoutGuide(layoutGuide)
            } else {
                self = .none
            }
        }
        
        func anchor(for attribute: NSLayoutConstraint.Attribute) -> AnyAnchor {
            switch self {
            case .none:
                return .idontknow
            case .view(let uIView):
                return uIView.anchor(for: attribute)
            case .layoutGuide(let uILayoutGuide):
                return uILayoutGuide.anchor(for: attribute)
            }
        }
    }
    
}
