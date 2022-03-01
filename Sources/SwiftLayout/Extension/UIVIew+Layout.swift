//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension UIView: Layout {}

public extension UIView {
    func traverse(_ superview: UIView?, traverseHandler handler: TraverseHandler) {
        _ = handler(.init(superview: superview, view: self))
    }
    func traverse(_ superview: UIView?, constraintHndler handler: ConstraintHandler) {
        handler(superview, self, [])
    }
    func setAnimationHandler(_ handler: @escaping (UIView) -> Void) -> some Layout {
        ViewLayout(self, sublayout: EmptyLayout()).setAnimationHandler(handler)
    }
}

public extension Layout where Self: UIView {
    func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    func config(_ config: (Self) -> Void) -> ViewLayout<Self, EmptyLayout> {
        config(self)
        return ViewLayout(self, sublayout: EmptyLayout())
    }
    
    func setAnimationHandler(_ handler: @escaping (UIView) -> Void) -> ViewLayout<Self, EmptyLayout> {
        let layout = ViewLayout(self, sublayout: EmptyLayout())
        return layout.setAnimationHandler(handler)
    }
}
