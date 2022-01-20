//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

protocol _ConstraintElements: ConstraintElements {
    
    var view: UIView { get }
    
    var _top: _Constraint { get }
    var _bottom: _Constraint { get }
    var _leading: _Constraint { get }
    var _trailing: _Constraint { get }
    var _centerX: _Constraint { get }
    var _centerY: _Constraint { get }
    var _width: _Constraint { get }
    var _height: _Constraint { get }
}

public protocol ConstraintElements {
    var top: Constraint { get }
    var bottom: Constraint { get }
    var leading: Constraint { get }
    var trailing: Constraint { get }
    var centerX: Constraint { get }
    var centerY: Constraint { get }
    var width: Constraint { get }
    var height: Constraint { get }
}

extension _ConstraintElements {
    
    var _top: _Constraint {
        ConstraintSingleEqual(element: VerticalConstraint(view: view, type: .top))
    }
    var _bottom: _Constraint {
        ConstraintSingleEqual(element: VerticalConstraint(view: view, type: .bottom))
    }
    var _leading: _Constraint {
        ConstraintSingleEqual(element: HorizontalConstraint(view: view, type: .leading))
    }
    var _trailing: _Constraint {
        ConstraintSingleEqual(element: HorizontalConstraint(view: view, type: .trailing))
    }
    var _centerX: _Constraint {
        ConstraintSingleEqual(element: HorizontalConstraint(view: view, type: .centerX))
    }
    var _centerY: _Constraint {
        ConstraintSingleEqual(element: VerticalConstraint(view: view, type: .centerY))
    }
    var _width: _Constraint {
        ConstraintSingleEqual(element: DimensionConstraint(view: view, type: .width))
    }
    var _height: _Constraint {
        ConstraintSingleEqual(element: DimensionConstraint(view: view, type: .width))
    }
    
    public var top: Constraint {
        _top
    }
    public var bottom: Constraint {
        _bottom
    }
    public var leading: Constraint {
        _leading
    }
    public var trailing: Constraint {
        _trailing
    }
    public var centerX: Constraint {
        _centerX
    }
    public var centerY: Constraint {
        _centerY
    }
    public var width: Constraint {
        _width
    }
    public var height: Constraint {
        _height
    }
}
