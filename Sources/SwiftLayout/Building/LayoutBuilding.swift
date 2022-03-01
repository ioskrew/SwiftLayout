//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol LayoutBuilding: AnyObject {
    associatedtype LayoutBody: Layout
    var layout: LayoutBody { get }
    var deactivable: Deactivable? { get set }
}

public extension LayoutBuilding {
    
    func updateLayout(animated: Bool) {
        self.updateLayout(animated ? .usingAnimation : [])
    }
    
    func updateLayout(_ options: LayoutOptions = []) {
        let layout = self.layout
        
        if options.contains(.automaticIdentifierAssignment) {
            _ = layout.updateIdentifiers(rootObject: self)
        }
        
        if let deactivation = self.deactivable as? Deactivation {
            Activator.update(layout: layout, fromDeactivation: deactivation, options: options)
        } else {
            let deactivation = Activator.active(layout: layout, options: options )
            self.deactivable = deactivation
        }
    }
    
}
