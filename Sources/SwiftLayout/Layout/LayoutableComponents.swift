//
//  LayoutableComponents.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

struct LayoutableComponents: Layoutable {
    let layoutables: [Layoutable]
    
    var views: [UIView] {
        layoutables.compactMap(cast(ViewContainLayoutable.self)).compactMap(\.view)
    }
    
    init(_ layoutables: [Layoutable]) {
        self.layoutables = layoutables
    }
    
    func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        guard let view = layoutable.view else { return layoutable }
        views.forEach(view.addSubview)
        return layoutable
    }
}
