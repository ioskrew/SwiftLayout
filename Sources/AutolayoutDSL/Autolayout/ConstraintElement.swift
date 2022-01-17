//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit
import SwiftUI

public protocol ConstraintElement {
    var view: UIView { get }
    func equalTo(_ element: ConstraintElement) -> ConstraintDSLContent
}

enum ConstraintLayoutType {
    case top, bottom, leading, trailing
    case centerX, centerY
    case width, height
}

protocol _ConstraintElement: ConstraintElement {
    var type: ConstraintLayoutType { get }
}

struct HorizontalConstraint: _ConstraintElement {
    let view: UIView
    let type: ConstraintLayoutType
    
    var anchor: NSLayoutXAxisAnchor {
        switch type {
        case .leading:
            return view.leadingAnchor
        case .trailing:
            return view.trailingAnchor
        case .centerX:
            return view.centerXAnchor
        default:
            fatalError()
        }
    }
    
    public func equalTo(_ element: ConstraintElement) -> ConstraintDSLContent {
        guard let same = element as? Self else { return _ConstraintDSLContent(constraints: []) }
        return _ConstraintDSLContent(constraints: [anchor.constraint(equalTo: same.anchor)])
    }
}

struct VerticalConstraint: _ConstraintElement {
    let view: UIView
    let type: ConstraintLayoutType
    
    var anchor: NSLayoutYAxisAnchor {
        switch type {
        case .top:
            return view.topAnchor
        case .bottom:
            return view.bottomAnchor
        case .centerY:
            return view.centerYAnchor
        default:
            fatalError()
        }
    }
    
    public func equalTo(_ element: ConstraintElement) -> ConstraintDSLContent {
        guard let same = element as? Self else { return _ConstraintDSLContent(constraints: []) }
        return _ConstraintDSLContent(constraints: [anchor.constraint(equalTo: same.anchor)])
    }
}

struct DimensionConstraint: _ConstraintElement {
    let view: UIView
    let type: ConstraintLayoutType
    
    var dimension: NSLayoutDimension {
        switch type {
        case .width:
            return view.widthAnchor
        case .height:
            return view.heightAnchor
        default:
            fatalError()
        }
    }
    
    func equalTo(_ element: ConstraintElement) -> ConstraintDSLContent {
        guard let same = element as? Self else { return _ConstraintDSLContent(constraints: []) }
        return _ConstraintDSLContent(constraints: [dimension.constraint(equalTo: same.dimension)])
    }
}
