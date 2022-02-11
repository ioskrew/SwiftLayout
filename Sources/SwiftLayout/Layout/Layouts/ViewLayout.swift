//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public final class ViewLayout<L>: ViewContainableLayout where L: ContainableLayout {
    
    internal init(view: UIView, layoutable: L) {
        self.view = view
        self.layoutable = layoutable
    }
    
    private weak var superview: UIView?
    public let view: UIView
    
    var layoutable: L
    
    public var layouts: [Layout] {
        layoutable.layouts
    }
    
    public func prepareSuperview(_ superview: UIView?) {
        self.superview = superview
        for layout in layouts {
            layout.prepareSuperview(view)
        }
    }
    
    public func attachSuperview() {
        if let superview = superview {
            superview.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        for layout in layouts {
            if let view = layout as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.view.addSubview(view)
            } else if let views = layout as? [UIView] {
                for view in views {
                    view.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(view)
                }
            } else {
                layout.attachSuperview()
            }
        }
    }
}

extension ViewLayout: LayoutFlattening {}
