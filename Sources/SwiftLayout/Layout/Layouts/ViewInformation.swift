//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

public final class ViewInformation: Hashable {
    
    public static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public init(superview: UIView?, view: UIView?, identifier: String?) {
        self.superview = superview
        self.view = view
        self.identifier = identifier
    }
    
    private(set) weak var superview: UIView?
    private(set) weak var view: UIView?
    let identifier: String?
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
        hasher.combine(identifier)
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
        .init(superview: superview, view: view, identifier: identifier)
    }
}
