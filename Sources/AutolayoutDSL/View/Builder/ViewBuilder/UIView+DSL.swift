//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public extension UIView {
    
    @discardableResult
    func callAsFunction(@ViewBuilder _ content: () -> ViewBuilding) -> ViewDSL {
        let container = ViewContainer(self)
        container.add(content().containers)
        return container
    }
    
    var dsl: ViewDSL { ViewContainer(self) }
}
