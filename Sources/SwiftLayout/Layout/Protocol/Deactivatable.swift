//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation

public protocol Deactivatable {
    func deactive()
}

public extension Deactivatable {
    func eraseToAnyDeactivatable() -> AnyDeactivatable {
        if let any = self as? AnyDeactivatable {
            return any
        }
        
        return AnyDeactivatable(self)
    }
}

