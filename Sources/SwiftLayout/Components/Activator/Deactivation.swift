//
//  Deactivation.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit

final class Deactivation: Deactivable {
    
    typealias Constraints = Set<WeakReference<NSLayoutConstraint>>
    
    convenience init() {
        self.init(viewInfos: .init(), constraints: .init())
    }
    
    init(viewInfos: ViewInformationSet, constraints: Constraints) {
        self.viewInfos = viewInfos
        self.constraints = constraints
    }
    
    deinit {
        deactive()
    }
    
    var viewInfos: ViewInformationSet
    var constraints: Constraints
    
    func deactive() {
        deactiveViews()
        deactiveConstraints()
    }
    
    func deactiveConstraints() {
        let constraints = constraints.compactMap(\.origin).filter(\.isActive)
        NSLayoutConstraint.deactivate(constraints)
        self.constraints = .init()
    }
    
    func deactiveViews() {
        let views = viewInfos.infos.compactMap(\.view)
        for view in views {
            if views.contains(where: { $0 == view.superview }) {
                view.removeFromSuperview()
            }
        }
        self.viewInfos = .init()
    }
    
    func viewForIdentifier(_ identifier: String) -> UIView? {
        viewInfos.infos.first(where: { $0.identifier == identifier })?.view
    }
}
