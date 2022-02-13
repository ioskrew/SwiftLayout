//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

public final class ViewPair: Hashable {
    
    public static func == (lhs: ViewPair, rhs: ViewPair) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public init(superview: UIView?, view: UIView?) {
        self.superview = superview
        self.view = view
    }
    
    private(set) weak var superview: UIView?
    private(set) weak var view: UIView?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
    }
    
    func addSuperview() {
        guard let view = view else {
            return
        }
        guard let superview = superview, superview != view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(view)
    }
    
    func removeFromSuperview() {
        view?.removeFromSuperview()
    }
    
    func updatingSuperview(_ superview: UIView?) -> Self {
        .init(superview: superview, view: view)
    }
}
