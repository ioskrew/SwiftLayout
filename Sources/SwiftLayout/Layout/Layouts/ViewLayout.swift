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
    
    internal(set) public var view: UIView
    var layoutable: L
    
    public var layouts: [Layout] {
        layoutable.layouts
    }
}
