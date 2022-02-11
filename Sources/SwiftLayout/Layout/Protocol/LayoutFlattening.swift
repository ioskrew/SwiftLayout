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

extension LayoutFlattening where Self: ContainableLayout {
    var layoutViews: [UIView] {
        (layouts as? [LayoutFlattening] ?? []).flatMap(\.layoutViews)
    }
    var layoutConstraints: [NSLayoutConstraint] {
        (layouts as? [LayoutFlattening] ?? []).flatMap(\.layoutConstraints)
    }
}

extension LayoutFlattening where Self: ViewContainableLayout {
    var layoutViews: [UIView] {
        var views: [UIView] = [view]
        views.append(contentsOf: (layouts as? [LayoutFlattening] ?? []).flatMap(\.layoutViews))
        return views
    }
}
