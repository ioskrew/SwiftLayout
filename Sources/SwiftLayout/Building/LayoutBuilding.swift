//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

public protocol LayoutBuilding: AnyObject {
 
    associatedtype LayoutContent: Layout
    
    var activation: Activation? { get set }
    var layout: LayoutContent { get }
    
    func updateLayout()
    
}

public extension LayoutBuilding {
    
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
