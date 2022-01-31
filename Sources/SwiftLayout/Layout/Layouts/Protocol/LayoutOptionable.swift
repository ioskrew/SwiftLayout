//
//  LayoutOptionable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

public protocol LayoutOptionable: LayoutAttachable {
    associatedtype Wrapped: LayoutAttachable
}

extension Optional: Layout where Wrapped: LayoutAttachable {
    public func active() -> AnyLayout {
        self?.active() ?? AnyLayout(nil)
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
        guard let attachable = self else { return }
        attachable.attachLayout(layout)
    }
}
