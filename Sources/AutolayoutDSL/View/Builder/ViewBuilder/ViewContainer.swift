//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

final class ViewContainer: ViewDSL, _ConstraintElements {
    
    let view: UIView
    
    var subcontainers: [ViewDSL] = []
    
    var tag: String = ""
    
    init(_ view: UIView) {
        self.view = view
    }
    
    func tag(_ tag: String) -> Self {
        self.tag = tag
        return self
    }
    
    func tag(_ tag: String, @ViewDSLBuilder content: () -> ViewBuilding) -> Self {
        self.tag = tag
        add(content().containers)
        return self
    }
    
    func add(_ view: UIView) {
        add(ViewContainer(view))
    }
    
    func add(_ container: ViewDSL) {
        add([container])
    }
    
    func add(_ containers: [ViewDSL]) {
        subcontainers.append(contentsOf: containers)
        for view in containers.map(\.view) {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }
    }
    
    var address: String {
        Unmanaged.passUnretained(view).toOpaque().debugDescription
    }
    
    var identity: String {
        tag.isEmpty ? address : tag
    }
    
    public var debugDescription: String {
        if subcontainers.isEmpty {
            return identity
        } else {
            return "\(identity): [\(subcontainers.map(\.debugDescription).joined(separator: ", "))]"
        }
    }
    
    // MARK: - Constraints
    
    func layout(_ content: () -> Constraints) -> Self {
        let constraints = content().constraints
        NSLayoutConstraint.activate(constraints)
        return self
    }
}
