//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/18.
//

import Foundation
import UIKit

final class ViewContainer: ViewDSL {
    
    let view: UIView
    
    var subcontainers: [ViewDSL] = []
    
    var tag: String = ""
    
    init(_ view: UIView) {
        self.view = view
    }
    
    func callAsFunction(_ content: () -> ViewBuilding) -> ViewDSL {
        add(content().containers)
        return self
    }

    func tag(_ tag: String) -> Self {
        self.tag = tag
        return self
    }
    
    func tag(_ tag: String, @ViewBuilder content: () -> ViewBuilding) -> Self {
        self.tag = tag
        add(content().containers)
        return self
    }
    
    func add(_ container: ViewDSL) {
        subcontainers.append(container)
        view.addSubview(container.view)
    }
    
    func add(_ containers: [ViewDSL]) {
        subcontainers.append(contentsOf: containers)
        containers.map(\.view).forEach(view.addSubview)
    }
    
    func add(_ view: UIView) {
        subcontainers.append(ViewContainer(view))
        view.addSubview(view)
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
}
