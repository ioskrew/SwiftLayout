//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

public protocol LayoutBuilding: AnyObject {
 
    associatedtype LayoutContent: Layout
    
    var layout: LayoutContent { get }
    
    func updateLayout()
    
}

final class LayoutBuildActivationKey {
    static var key = LayoutBuildActivationKey()
}

public extension LayoutBuilding where Self: NSObject {
    
    internal var activation: Activation? {
        get {
            objc_getAssociatedObject(self, &LayoutBuildActivationKey.key) as? Activation
        }
        set {
            objc_setAssociatedObject(self, &LayoutBuildActivationKey.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func updateLayout() {
        let layout: some Layout = self.layout
        if let activation = self.activation {
            guard activation.isNew(layout) else { return }
            self.activation?.deactive()
            self.activation = nil
        }
        self.activation = Activation(layout)
        self.activation?.active()
    }
    
}
