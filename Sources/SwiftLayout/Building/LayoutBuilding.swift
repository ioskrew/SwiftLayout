//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol LayoutBuilding: AnyObject {
    var layout: Layout { get }
    var deactivable: Deactivable? { get set }
}

public extension LayoutBuilding {
    
    func updateLayout(animated: Bool = false) {        
        guard let layoutImp = self.layout as? LayoutImp else {
            return
        }
        
        if let deactivation = self.deactivable as? Deactivation {
            Activator.update(layout: layoutImp, fromDeactivation: deactivation)
        } else {
            self.deactivable = Activator.active(layout: layoutImp)
        }
    }
    
}
