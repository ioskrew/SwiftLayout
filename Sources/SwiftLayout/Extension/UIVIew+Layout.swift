//
//  UIVIew+Layout.swift
//  
//
//  Created by aiden_h on 2022/02/21.
//

import UIKit

extension UIView: Layout {}

public extension UIView {
    func traverse(_ superview: UIView?, continueAfterViewLayout: Bool, traverseHandler handler: TraverseHandler) {
        handler(.init(superview: superview, view: self))
    }
    func traverse(_ superview: UIView?, viewInfoSet: ViewInformationSet, constraintHndler handler: ConstraintHandler) {
        handler(superview, self, [], viewInfoSet)
    }
}

public extension Layout where Self: UIView {
    func callAsFunction<L: Layout>(@LayoutBuilder _ build: () -> L) -> some Layout {
        ViewLayout(self, sublayout: build())
    }
    
    func config(_ config: (Self) -> Void) -> some Layout {
        config(self)
        return ViewLayout(self, sublayout: EmptyLayout())
    }
}
