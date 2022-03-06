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
    var activation: Activation? { get set }
}

public extension LayoutBuilding {
    
    func updateLayout(animated: Bool) {
        self.updateLayout(animated ? .usingAnimation : [])
    }
    
    func updateLayout(_ options: LayoutOptions = []) {
        let layout = self.layout
        
        self.activation = Activator.update(layout: layout, fromActivation: activation ?? Activation())
    }
}
