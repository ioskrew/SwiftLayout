//
//  AnchorLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/03.
//

import Foundation

public struct AnchorLayout<A>: LayoutAttachable where A: NSLayoutAnchorConstraint, A: NSObject {
    
    internal init(_ anchor: A) {
        self.anchor = anchor
    }
    
    let anchor: A
    
    public func active() -> AnyDeactivatable {
        AnyDeactivatable()
    }
    
    public func deactive() {
        
    }
    
    public func attachConstraint(_ constraint: Constraint) {
        
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        
    }
    
    public var hashable: AnyHashable {
        AnyHashable(anchor)
    }
    
}
