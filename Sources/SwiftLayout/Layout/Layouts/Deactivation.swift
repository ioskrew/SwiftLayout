//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation

final class Deactivation: Deactivable {
    
    init(_ layout: Layout) {
        updateLayout(layout)
    }
    
    deinit {
        deactive()
    }
    
    func deactive() {
    }
    
    func updateLayout(_ layout: Layout) {
        layout.prepareSuperview(nil)
        layout.attachSuperview()
        layout.prepareConstraints()
        layout.activeConstraints()
    }
    
}
