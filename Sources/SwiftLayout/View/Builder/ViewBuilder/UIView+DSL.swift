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
    func callAsFunction(@ViewDSLBuilder _ content: () -> ViewBuilding) -> ViewDSL {
        let container = ViewContainer(self)
        container.add(content().containers)
        return container
    }
    
    var dsl: ViewDSL { _dsl }
}

extension UIView {
    
    var _dsl: ViewContainer { ViewContainer(self) }
    
}
