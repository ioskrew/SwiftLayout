//
//  TupleLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public struct TupleLayout<Tuple>: AttachableLayout, LayoutContainable {
    
    let tuple: Tuple
    
    public var layouts: [AttachableLayout] { [] }
    
    public func attachLayout(_ layout: AttachableLayout) {
        
    }
    
    public func deactive() {
        
    }
    
    public var equation: AnyHashable {
        AnyHashable(0)
    }
    
    
}
