//
//  Optional+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

extension Optional: Layout where Wrapped: Layout {
    public func active() -> AnyDeactivatable {
        self?.active() ?? AnyDeactivatable()
    }
    
    public func deactive() {
        self?.deactive()
    }
    
    public var equation: AnyHashable {
        self?.equation ?? AnyHashable(0)
    }
}

extension Optional: LayoutAttachable where Wrapped: LayoutAttachable {
    public func attachLayout(_ layout: LayoutAttachable) {
        self?.attachLayout(layout)
    }
}
