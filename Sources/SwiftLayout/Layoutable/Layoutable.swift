//
//  LayoutBuilding.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

public protocol Layoutable: AnyObject {
    associatedtype LayoutBody: Layout
    var activation: Activation? { get set }
    @LayoutBuilder var layout: LayoutBody { get }
}

public extension Layoutable {
    
    func initLayout() {
        updateLayout()
        let mirror = Mirror(reflecting: self)
        for child in mirror.children {
            if let equatablePublisher = child.value as? LayoutPropertyEquatablePublisherable {
                activation?.store(equatablePublisher.property.sink(receiveValue: { [weak self] _ in
                    self?.updateLayout()
                }))
            } else if let publisher = child.value as? LayoutPropertyPublisherable {
                activation?.store(publisher.property.sink(receiveValue: { [weak self] _ in
                    self?.updateLayout()
                }))
            }
        }
    }
    
    func updateLayout() {
        self.activation = Activator.update(layout: layout, fromActivation: activation ?? Activation())
    }
}
