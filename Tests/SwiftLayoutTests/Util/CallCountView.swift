//
//  CallCountView.swift
//  
//
//  Created by aiden_h on 2022/04/02.
//

import UIKit

class CallCountView: UIView {
    var addSubviewCounts: [UIView: Int] = [:]
    
    func addSubviewCallCount(_ view: UIView) -> Int {
        addSubviewCounts[view] ?? 0
    }
    
    var removeFromSuperviewCallCount: Int = 0
    
    override func addSubview(_ view: UIView) {
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
