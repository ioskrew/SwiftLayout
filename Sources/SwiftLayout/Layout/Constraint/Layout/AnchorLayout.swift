//
//  AnchorLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/03.
//

import Foundation

public struct AnchorLayout<Anchor>: LayoutAttachable where Anchor: NSLayoutAnchorConstraint, Anchor: NSObject {
    
    internal init(_ anchors: [Anchor]) {
        self.anchors = anchors
    }
    
    let anchors: [Anchor]
    
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
        AnyHashable(anchors)
    }
    
}
