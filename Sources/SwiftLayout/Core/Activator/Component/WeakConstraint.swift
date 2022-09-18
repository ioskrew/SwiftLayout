//
//  WeakConstraint.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import UIKit

final class WeakConstraint {
    weak var origin: NSLayoutConstraint?

    init(origin: NSLayoutConstraint? = nil) {
        self.origin = origin
    }
}
extension WeakConstraint: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(origin?.firstItem as? NSObject)
        hasher.combine(origin?.firstAttribute)
        hasher.combine(origin?.secondItem as? NSObject)
        hasher.combine(origin?.secondAttribute)
        hasher.combine(origin?.relation)
        hasher.combine(origin?.constant)
        hasher.combine(origin?.multiplier)
        hasher.combine(origin?.priority)
    }

    static func == (lhs: WeakConstraint, rhs: WeakConstraint) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension Collection where Element: NSLayoutConstraint {
    var weakens: [WeakConstraint] {
        map(WeakConstraint.init)
    }
}
