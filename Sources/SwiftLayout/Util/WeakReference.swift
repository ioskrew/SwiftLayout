//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import Foundation
import UIKit

protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
}

final class WeakReference<O>: Hashable where O: CustomHashable {
    static func == (lhs: WeakReference<O>, rhs: WeakReference<O>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(o: O? = nil) {
        self.o = o
    }
    
    weak var o: O?
    
    func hash(into hasher: inout Hasher) {
        o?.customHash(&hasher)
    }
}

extension NSLayoutConstraint: CustomHashable {
    func customHash(_ hasher: inout Hasher) {
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

extension WeakReference: CustomDebugStringConvertible where O: NSLayoutConstraint {
    var debugDescription: String {
        guard let o = o else { return "WK constraint: unknown: \(UUID().uuidString)" }
        guard let first = o.firstItem as? UIView else { return "WK constraint: unknown: \(UUID().uuidString)" }
        if let second = o.secondItem as? UIView {
            return "WK constraint: \(first.tagDescription) \(o.relation)[\(o.constant)x\(o.multiplier)] \(second.tagDescription)"
        } else {
            return "WK constraint: \(first.tagDescription) \(o.relation)[\(o.constant)x\(o.multiplier)]"
        }
    }
}

extension Collection where Element: CustomHashable {
    var weakens: [WeakReference<Element>] {
        map(WeakReference.init)
    }
}
