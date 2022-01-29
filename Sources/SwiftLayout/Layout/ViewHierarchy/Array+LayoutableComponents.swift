//
//  Array+LayoutableComponents.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

public extension Array where Element: Layoutable {
    
    func anyLayoutable() -> Layoutable {
        AnyLayoutable(.init(layoutable: LayoutableComponents(self)))
    }
    
}
