//
//  CallCountView.swift
//  

import SwiftLayoutPlatform

class CallCountView: SLView {
    var addSubviewCounts: [SLView: Int] = [:]

    func addSubviewCallCount(_ view: SLView) -> Int {
        addSubviewCounts[view] ?? 0
    }

    var removeFromSuperviewCallCount: Int = 0

    override func addSubview(_ view: SLView) {
        if let count = addSubviewCounts[view] {
            addSubviewCounts[view] = count + 1
        } else {
            addSubviewCounts[view] = 1
        }
        super.addSubview(view)
    }

    override func removeFromSuperview() {
        removeFromSuperviewCallCount += 1
        super.removeFromSuperview()
    }
}
