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
    var deactivatable: Deactivable? { get set }
    
}

public extension LayoutBuilding where Self: NSObject {
    
    func updateLayout() {
        let layout: some Layout = self.layout
        
        if let deactivatable = self.deactivatable as? Deactivation {
            deactivatable.updateLayout(layout)
        } else {
            self.deactivatable = Deactivation(layout)
        }
        
    }
    
}
