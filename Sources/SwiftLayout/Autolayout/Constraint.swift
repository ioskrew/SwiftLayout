//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

public protocol Constraint {
    var view: UIView { get }
//    func to(_ constraint: Constraint) -> ConstraintDSLContent
//    func to(_ view: UIView) -> ConstraintDSLContent
}

protocol _Constraint: Constraint {
    var element: _ConstraintElement { get }
}

extension _Constraint {
    var view: UIView { element.view }
}

struct ConstraintSingleEqual: _Constraint {
    
    let element: _ConstraintElement
    
//    func to(_ constraint: Constraint) -> ConstraintDSLContent {
//        guard let same = constraint as? Self else { return _ConstraintDSLContent(constraints: []) }
//        return element.equalTo(same.element)
//    }
//    
//    func to(_ view: UIView) -> ConstraintDSLContent {
//        switch element.type {
//        case .top:
//            return element.equalTo(view._dsl._top.element)
//        case .bottom:
//            return element.equalTo(view._dsl._bottom.element)
//        case .leading:
//            return element.equalTo(view._dsl._leading.element)
//        case .trailing:
//            return element.equalTo(view._dsl._trailing.element)
//        case .centerX:
//            return element.equalTo(view._dsl._centerX.element)
//        case .centerY:
//            return element.equalTo(view._dsl._centerY.element)
//        case .width:
//            return element.equalTo(view._dsl._width.element)
//        case .height:
//            return element.equalTo(view._dsl._height.element)
//        }
//    }
}
