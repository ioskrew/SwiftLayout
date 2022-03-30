//
//  AnchorsContainer.swift
//  
//
//  Created by aiden_h on 2022/03/27.
//

import UIKit

public final class AnchorsContainer {
    
    private var constraints: [AnchorsContainable] = []
    
    init() {
        self.constraints = []
    }
    
    init(_ containable: AnchorsContainable) {
        self.constraints = [containable]
    }
    
    func append(_ container: AnchorsContainer) {
        self.constraints.append(contentsOf: container.constraints)
    }
    
    func append(_ containable: AnchorsContainable) {
        self.constraints.append(containable)
    }
    
    func constraints(item fromItem: NSObject, toItem: NSObject?, viewDic: [String: UIView] = [:]) -> [NSLayoutConstraint] {
        constraints.flatMap {
            $0.nsLayoutConstraint(item: fromItem, toItem: toItem, viewDic: viewDic)
        }
    }
    
    public func multiplier(_ multiplier: CGFloat) -> Self {
        for i in 0..<constraints.count {
            constraints[i].setMultiplier(multiplier)
        }
        return self
    }
}

// MARK: - Support SwiftLayoutPrinter
public struct AnchorsConstraintProperty {
    public let attribute: NSLayoutConstraint.Attribute
    public let relation: NSLayoutConstraint.Relation
    public let toItem: AnchorsItem
    public let toAttribute: NSLayoutConstraint.Attribute?
    public let constant: CGFloat
    public let multiplier: CGFloat
}

extension AnchorsContainer {
    public func getConstraintProperties() -> [AnchorsConstraintProperty] {
        constraints.flatMap { $0.getConstraintProperties() }
    }
}
