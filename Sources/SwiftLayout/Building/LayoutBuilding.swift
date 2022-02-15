//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol LayoutBuilding: AnyObject {
 
    associatedtype LayoutContent: Layout
    
    var layout: LayoutContent { get }
    var deactivatable: Deactivable? { get set }
    
}

public extension LayoutBuilding {
    
    func updateLayout(animated: Bool = false) {
        let layout: some Layout = self.layout
        
        if let deactivatable = self.deactivatable as? Deactivation {
            guard let impl = layout as? LayoutImpl else { return }
            deactivatable.updateLayout(impl, animated: animated)
        } else {
            self.deactivatable = Deactivation(layout)
        }
    }
    
}
