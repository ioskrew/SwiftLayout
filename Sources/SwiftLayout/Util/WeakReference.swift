//
//  WeakReference.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import UIKit

protocol CustomHashable: AnyObject {
    func customHash(_ hasher: inout Hasher)
}

final class WeakReference<Origin>: Hashable where Origin: CustomHashable {
    static func == (lhs: WeakReference<Origin>, rhs: WeakReference<Origin>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    init(origin: Origin? = nil) {
        self.origin = origin
    }
    
    weak var origin: Origin?
    
    func hash(into hasher: inout Hasher) {
        origin?.customHash(&hasher)
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

extension Collection where Element: CustomHashable {
    var weakens: [WeakReference<Element>] {
        map(WeakReference.init)
    }
}
