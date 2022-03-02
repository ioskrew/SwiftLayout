//
//  AnyDeactivable.swift
//  
//
//  Created by oozoofrog on 2022/02/23.
//

import Foundation
import UIKit

public final class AnyDeactivable: Deactivable, Hashable {
    
    typealias Constraints = Set<WeakReference<NSLayoutConstraint>>
    
    public static func == (lhs: AnyDeactivable, rhs: AnyDeactivable) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    var deactivable: Deactivable
    
    var viewInfos: ViewInformationSet?
    var constraints: Constraints?
    
    init(_ deactivation: Deactivation) {
        deactivable = deactivation
        viewInfos = deactivation.viewInfos
        constraints = deactivation.constraints
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(viewInfos)
        hasher.combine(constraints)
    }
    
    public func deactive() {
        viewInfos = nil
        constraints = nil
        deactivable.deactive()
    }
    
    public func viewForIdentifier(_ identifier: String) -> UIView? {
        deactivable.viewForIdentifier(identifier)
    }
    
    public func store<C: RangeReplaceableCollection>(_ store: inout C) where C.Element == AnyDeactivable {
        store.append(self)
    }
    
    public func store(_ store: inout Set<AnyDeactivable>) {
        store.insert(self)
    }
}
