//
//  NSLayoutAnchor+AnchorType.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol AnchorTypeInterface {
    var anchorType: AnchorType { get }
}

extension AnchorTypeInterface where Self: NSObject {
    public var anchorType: AnchorType {
        AnchorType(self)
    }
}

extension NSLayoutAnchor: AnchorTypeInterface {}

public enum AnchorType: AnchorTypeInterface {
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
    
    public var anchorType: AnchorType { self }
    
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
    
    func constraint<A: AnchorTypeInterface>(to second: A?, relation: NSLayoutConstraint.Relation, constant: CGFloat) -> NSLayoutConstraint? {
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
    
    func equal<A: AnchorTypeInterface>(with second: A, constant: CGFloat = CGFloat.zero) -> NSLayoutConstraint? {
        constraint(to: second, relation: .equal, constant: constant)
    }
    
}
