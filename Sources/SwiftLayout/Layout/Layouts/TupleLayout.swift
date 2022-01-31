//
//  TupleLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation
import UIKit

public struct TupleLayout<Tuple>: LayoutAttachable, LayoutContainable {
    
    let tuple: Tuple
    
    public var layouts: [LayoutAttachable] { castArrayFromTuple() }
    
    public func deactive() {}
    
    func castArrayFromTuple() -> [LayoutAttachable] {
       []
    }
    
    public var equation: AnyHashable {
        AnyHashable(0)
    }
    
}
