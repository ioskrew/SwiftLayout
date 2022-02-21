//
//  Deactivation.swift
//  
//
//  Created by aiden_h on 2022/02/16.
//

import UIKit

final class Deactivation<LB: LayoutBuilding>: Deactivable {
    
    convenience init(building: LB? = nil) {
        self.init(viewInfos: .init(), constraints: .init(), building: building)
    }
    
    init(viewInfos: ViewInformationSet, constraints: ConstraintsSet, building: LB? = nil) {
        self.viewInfos = viewInfos
        self.constraints = constraints
        self.building = building
    }
    
    deinit {
        deactive()
    }
    
    var viewInfos: ViewInformationSet
    var constraints: ConstraintsSet
    
    /// injected on activating
    private(set) weak var building: LB?
    
    func deactive() {
        deactiveViews()
        deactiveConstraints()
    }
    
    func deactiveConstraints() {
        let constraints = constraints.constraints.compactMap(\.origin).filter(\.isActive)
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

struct ConstraintsSet {
    
    let constraints: Set<WeakReference<NSLayoutConstraint>>
    
    init(constraints: [NSLayoutConstraint] = []) {
        self.constraints = Set(constraints.weakens)
    }
}
