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
    
    func updateLayout(animated: Bool) {
        self.updateLayout(animated ? .usingAnimation : [])
    }
    
    func updateLayout(_ options: LayoutOptions = []) {
        let layoutImps = self.layout.extractLayoutImpFromSelf()
        guard !layoutImps.isEmpty else { return }
        if let deactivation = self.deactivable as? Deactivation {
            Activator.update(layout: layoutImps, fromDeactivation: deactivation, options: options)
        } else {
            let deactivation = Activator.active(layout: layoutImps, options: options, building: self)
            self.deactivable = deactivation
        }
    }
    
}
