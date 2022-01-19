//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public struct ConstraintCompound {
    
    let view: UIView
    let constraints: [Constraint]
    
    public func to(_ view: UIView) -> ConstraintDSLContent {
        _ConstraintDSLContent(contents: constraints.map({ $0.to(view) }))
    }
    
    public var top: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.top])
    }
    public var bottom: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.bottom])
    }
    public var leading: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.leading])
    }
    public var trailing: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.trailing])
    }
    public var centerX: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.centerX])
    }
    public var centerY: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.centerY])
    }
    public var width: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.width])
    }
    public var height: ConstraintCompound {
        .init(view: view, constraints: constraints + [view.dsl.height])
    }
    
}

extension Constraint {
    
    public var top: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.top])
    }
    public var bottom: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.bottom])
    }
    public var leading: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.leading])
    }
    public var trailing: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.trailing])
    }
    public var centerX: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.centerX])
    }
    public var centerY: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.centerY])
    }
    public var width: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.width])
    }
    public var height: ConstraintCompound {
        .init(view: view, constraints: [self, view.dsl.height])
    }
    
}
