//
//  ViewContainableLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol ViewContainable {
    var superview: UIView? { get set }
    var view: UIView { get }
    var animationDisabled: Bool { get }
    
    func updateSuperview(_ superview: UIView?)
}

extension Layout where Self: ViewContainable {
    
    public var layoutViews: [ViewPair] {
        [.init(superview: superview, view: view)] + sublayouts.layoutViews.map({ pair in
            if pair.superview == nil {
                return pair.updatingSuperview(view)
            } else {
                return pair
            }
        })
    }
    
    public var layoutConstraints: [NSLayoutConstraint] {
        sublayouts.layoutConstraints
    }
    
    public func prepareSuperview(_ superview: UIView?) {
        updateSuperview(superview)
        sublayouts.prepareSuperview(view)
    }
    
    public func animation() {
        if animationDisabled {
            view.layer.removeAllAnimations()
            sublayouts.animationDisable()
        }
        sublayouts.animation()
    }
    
}
