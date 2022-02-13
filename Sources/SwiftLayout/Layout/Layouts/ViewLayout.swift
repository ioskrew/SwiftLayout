//
//  ViewLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public final class ViewLayout {
    
    internal init(view: UIView, sublayouts: [Layout]) {
        self.view = view
        self.sublayouts = sublayouts
    }
    
    public weak var superview: UIView?
    public let view: UIView
    public let sublayouts: [Layout]

    public func updateSuperview(_ superview: UIView?) {
        self.superview = superview
    }
}

extension ViewLayout: Layout, ViewContainable {}
