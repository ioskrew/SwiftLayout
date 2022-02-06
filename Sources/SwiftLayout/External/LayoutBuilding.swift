//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

public protocol LayoutBuilding: AnyObject {
 
    associatedtype LayoutContent: Layout
    
    var deactivatable: AnyDeactivatable? { get set }
    var layout: LayoutContent { get }
    
    func update()
    
}

extension LayoutBuilding {
    
    func update() {
        let layout: some Layout = self.layout
        self.deactivatable?.deactive()
        self.deactivatable = nil
        self.deactivatable = AnyDeactivatable(layout)
        self.deactivatable?.active()
    }
    
}
