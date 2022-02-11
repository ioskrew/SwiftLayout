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
        self.strongView = view
        self.layoutable = layoutable
    }
    
    public var view: UIView? {
        if let view = self.strongView {
            return view
        } else if let view = self.weakView {
            return view
        } else {
            return nil
        }
    }
    
    private weak var weakView: UIView?
    private var strongView: UIView?
    
    var layoutable: L
    
    public var layouts: [Layout] {
        layoutable.layouts
    }
    
    public func attachSuperview(_ superview: UIView?) {
        guard let view = self.view else { return }
        superview?.addSubview(view)
        weakView = strongView
        strongView = nil
        for layout in layouts {
            layout.attachSuperview(view)
        }
    }
}
