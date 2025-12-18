//
//  WeakConstraint.swift
//  
//
//  Created by oozoofrog on 2022/02/12.
//

import SwiftLayoutPlatform

struct WeakConstraint {
    private(set) weak var origin: NSLayoutConstraint?
    private var customHashValue: Int

    @MainActor
    init(origin: NSLayoutConstraint? = nil) {
        self.origin = origin

        var hasher = Hasher()
        hasher.combine(origin?.firstItem as? NSObject)
        hasher.combine(origin?.firstAttribute)
        hasher.combine(origin?.secondItem as? NSObject)
        hasher.combine(origin?.secondAttribute)
        hasher.combine(origin?.relation)
        hasher.combine(origin?.constant)
        hasher.combine(origin?.multiplier)
        hasher.combine(origin?.priority)
        hasher.combine(origin?.identifier)
        self.customHashValue = hasher.finalize()
    }
}

extension WeakConstraint: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(customHashValue)
    }

    static func == (lhs: WeakConstraint, rhs: WeakConstraint) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

extension Set where Element == WeakConstraint {
    @MainActor
    init(ofWeakConstraintsFrom sequence: [NSLayoutConstraint]) {
        self.init(sequence.map(WeakConstraint.init))
    }
}
