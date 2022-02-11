//
//  AnyDeactivatable.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation

public final class AnyDeactivatable: Deactivatable {
    internal let origin: Deactivatable
    internal init<D>(_ deactivatable: D) where D : Deactivatable {
        self.origin = deactivatable
    }
    
    public func deactive() {
        origin.deactive()
    }
}
