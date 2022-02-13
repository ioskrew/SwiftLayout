//
//  InternalLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/11.
//

import Foundation
import UIKit

protocol LayoutFlattening {
    
    var layoutViews: [UIView] { get }
    var layoutConstraints: [NSLayoutConstraint] { get }
    
}

extension UIView: LayoutFlattening {    
    var layoutViews: [UIView] { [self] }
    var layoutConstraints: [NSLayoutConstraint] { [] }
}

extension Array: LayoutFlattening where Element == Layout {
    var layoutViews: [UIView] {
        compactMap({ $0 as? LayoutFlattening }).flatMap(\.layoutViews)
    }
    var layoutConstraints: [NSLayoutConstraint] {
        compactMap({ $0 as? LayoutFlattening }).flatMap(\.layoutConstraints)
    }
}

extension LayoutFlattening where Self: Layout {
    var layoutViews: [UIView] {
        sublayouts.layoutViews
    }
    var layoutConstraints: [NSLayoutConstraint] {
        sublayouts.layoutConstraints
    }
}

extension LayoutFlattening where Self: ViewContainable, Self: Layout {
    var layoutViews: [UIView] {
        var views: [UIView] = [view]
        views.append(contentsOf: sublayouts.layoutViews)
        return views
    }
}

extension LayoutFlattening {
    var viewReferences: Set<WeakReference<UIView>> {
        Set(layoutViews.map(WeakReference.init))
    }
    var constraintReferences: Set<WeakReference<NSLayoutConstraint>> {
        Set(layoutConstraints.map(WeakReference.init))
    }
}
