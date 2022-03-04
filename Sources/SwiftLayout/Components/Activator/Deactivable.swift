//
//  File.swift
//  
//
//  Created by aiden_h on 2022/02/10.
//

import Foundation
import UIKit

public protocol Deactivable {
    func deactive()
    func viewForIdentifier(_ identifier: String) -> UIView?
}

extension Deactivable {
    var deactivation: Deactivation? {
        if let deactivation = self as? Deactivation {
            return deactivation
        } else if let anyDeactivable = self as? AnyDeactivable, let deactivation = anyDeactivable.deactivable as? Deactivation {
            return deactivation
        } else {
            return nil
        }
    }
}
