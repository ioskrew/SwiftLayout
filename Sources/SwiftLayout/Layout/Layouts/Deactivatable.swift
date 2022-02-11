//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation

final class Deactivatable: Deactivable {
    var layout: Layout
    init(_ layout: Layout) {
        self.layout = layout
    }
    
    deinit {
        deactive()
    }
    
    func deactive() {
        layout.detachFromSuperview()
    }
}
