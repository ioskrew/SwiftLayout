//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import Foundation

protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
    func isLessThan(_ hashable: Self) -> Bool
}

final class WeakReference<Origin>: Hashable, Comparable where Origin: CustomHashable {
    static func < (lhs: WeakReference<Origin>, rhs: WeakReference<Origin>) -> Bool {
        if let lhs = lhs.origin {
            if let rhs = rhs.origin {
                return lhs.isLessThan(rhs)
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    static func == (lhs: WeakReference<Origin>, rhs: WeakReference<Origin>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    internal init(origin: Origin? = nil) {
        self.origin = origin
    }
    
    weak var origin: Origin?
    
    func hash(into hasher: inout Hasher) {
        origin?.customHash(&hasher)
    }
}

extension SLLayoutConstraint: CustomHashable {
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
    
    func isLessThan(_ hashable: SLLayoutConstraint) -> Bool {
        if firstAttribute.rawValue < hashable.firstAttribute.rawValue {
            return true
        } else if firstAttribute == hashable.firstAttribute {
            if secondAttribute.rawValue < hashable.secondAttribute.rawValue {
                return true
            } else if secondAttribute == hashable.secondAttribute {
                if relation.rawValue < hashable.relation.rawValue {
                    return true
                } else if relation == hashable.relation {
                    if constant < hashable.constant {
                        return true
                    } else if constant == hashable.constant {
                        if multiplier < hashable.multiplier {
                            return true
                        } else if multiplier == hashable.multiplier {
                            return priority < hashable.priority
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

extension WeakReference: CustomDebugStringConvertible where Origin: SLLayoutConstraint {
    var debugDescription: String {
        guard let origin = origin else { return "WK constraint: unknown: \(UUID().uuidString)" }
        guard let first = origin.firstItem as? SLView else { return "WK constraint: unknown: \(UUID().uuidString)" }
        if let second = origin.secondItem as? SLView {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription):\(origin.secondAttribute)"
        } else if let second = origin.secondItem as? SLLayoutGuide {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)] \(second.tagDescription):\(origin.secondAttribute)"
        } else {
            return "WK constraint: \(first.tagDescription):\(origin.firstAttribute) \(origin.relation)[\(origin.constant)x\(origin.multiplier)]"
        }
    }
}

extension Collection where Element: CustomHashable {
    var weakens: [WeakReference<Element>] {
        map(WeakReference.init)
    }
}
