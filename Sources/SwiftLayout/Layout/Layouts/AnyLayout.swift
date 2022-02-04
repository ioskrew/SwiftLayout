//
//  AnyLayoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/30.
//

import Foundation
import UIKit

final public class AnyLayout: Hashable, LayoutAttachable {
    
    public static func == (lhs: AnyLayout, rhs: AnyLayout) -> Bool {
        lhs.layout?.hashable == rhs.layout?.hashable
    }
    
    internal init(_ layoutable: LayoutAttachable?) {
        self.layout = layoutable
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(layout?.hashable)
    }
    
    public var layout: LayoutAttachable?
    
    deinit {
        layout?.deactive()
        layout = nil
    }
    
    public func active() -> AnyDeactivatable {
        return layout?.active() ?? AnyDeactivatable()
    }
    
    public func deactive() {
        layout?.deactive()
    }
    
    public func attachLayout(_ layout: LayoutAttachable) {
        self.layout?.attachLayout(layout)
    }
    
    public func constraints(with view: UIView) -> [NSLayoutConstraint] {
        self.layout?.constraints(with: view) ?? []
    }
    
    public var hashable: AnyHashable {
        AnyHashable(layout?.hashable)
    }
}
