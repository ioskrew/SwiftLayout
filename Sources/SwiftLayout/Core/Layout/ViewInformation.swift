//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import UIKit

final class ViewInformation: Hashable {
    
    init(superview: UIView?, view: UIView?) {
        self.superview = superview
        self.view = view
    }
    
    private(set) public weak var superview: UIView?
    private(set) public weak var view: UIView?
    var identifier: String? { view?.accessibilityIdentifier }
    
    func addSuperview() {
        guard let view = view else {
            return
        }
        if superview != view.superview {
            if let stackSuperView = superview as? UIStackView {
                stackSuperView.addArrangedSubview(view)
            } else {
                superview?.addSubview(view)
            }
        }
    }
    
    func removeFromSuperview() {
        guard superview == view?.superview else { return }
        view?.removeFromSuperview()
    }
}

// MARK: - Hashable
extension ViewInformation {
    
    static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(superview)
        hasher.combine(view)
    }
}
