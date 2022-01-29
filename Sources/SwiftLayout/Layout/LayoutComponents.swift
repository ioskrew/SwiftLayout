//
//  LayoutComponents.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation

struct LayoutComponents: Layoutable {
    let layoutables: [Layoutable]
    
    var views: [UIView] {
        layoutables.compactMap(cast(UIView.self))
    }
    
    func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        guard let view = layoutable.view else { return layoutable }
        views.forEach(view.addSubview)
        return layoutable
    }
}
