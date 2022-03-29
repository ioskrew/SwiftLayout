//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import UIKit

public protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
}

public final class WeakReference<Origin>: Hashable where Origin: CustomHashable {
    public static func == (lhs: WeakReference<Origin>, rhs: WeakReference<Origin>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public init(origin: Origin? = nil) {
        self.origin = origin
    }
    
    public weak var origin: Origin?
    
    public func hash(into hasher: inout Hasher) {
        origin?.customHash(&hasher)
    }
}

extension NSLayoutConstraint: CustomHashable {
    public func customHash(_ hasher: inout Hasher) {
        hasher.combine(firstItem as? NSObject)
        hasher.combine(firstAttribute)
        hasher.combine(secondItem as? NSObject)
        hasher.combine(secondAttribute)
        hasher.combine(relation)
        hasher.combine(constant)
        hasher.combine(multiplier)
        hasher.combine(priority)
    }
}

extension WeakReference: CustomDebugStringConvertible where Origin: NSLayoutConstraint {
    public var debugDescription: String {
        guard let origin = origin else { return "WK constraint: unknown: \(UUID().uuidString)" }
        guard let first = origin.firstItem as? UIView else { return "WK constraint: unknown: \(UUID().uuidString)" }
        if let second = origin.secondItem as? UIView {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription):\(origin.secondAttribute)"
        } else if let second = origin.secondItem as? UILayoutGuide {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription):\(origin.secondAttribute)"
        } else {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)]"
        }
    }
}

extension Collection where Element: CustomHashable {
    public var weakens: [WeakReference<Element>] {
        map(WeakReference.init)
    }
}
