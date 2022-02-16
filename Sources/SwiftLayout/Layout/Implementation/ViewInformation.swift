//
//  ViewPair.swift
//  
//
//  Created by oozoofrog on 2022/02/14.
//

import Foundation
import UIKit

final class ViewInformation: Hashable {
    
    static func == (lhs: ViewInformation, rhs: ViewInformation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    init(superview: UIView?, view: UIView?, identifier: String?, animationDisabled: Bool) {
        self.superview = superview
        self.view = view
        self.identifier = identifier
        self.animationDisabled = animationDisabled
    }
    
    private(set) weak var superview: UIView?
    private(set) weak var view: UIView?
    let identifier: String?
    let animationDisabled: Bool
    
    func hash(into hasher: inout Hasher) {
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
        .init(superview: superview, view: view, identifier: identifier, animationDisabled: animationDisabled)
    }
    
    func animation() {
        guard animationDisabled else { return }
        view?.layer.removeAllAnimations()
    }
}

public struct ViewInformationSet {
    
    let infos: Set<ViewInformation>
    
    init(infos: [ViewInformation] = []) {
        self.infos = Set(infos)
    }
    
    subscript(_ identifier: String) -> UIView? {
        infos.first(where: { $0.identifier == identifier })?.view
    }
}
