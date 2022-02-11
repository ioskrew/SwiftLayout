//
//  Anyactivation.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

protocol ActivationBox {
    
    var layouts: [Layout] { get }
    
    func active()
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
    func deactive()
    func layoutIsActivating<Layoutable>(_ layout: Layoutable) -> Bool where Layoutable: Layout
    
    func bind<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
}

final class _ActivationBox<Layoutable: Layout>: ActivationBox {
    
    internal init(_ layout: Layoutable) {
        self.layouts = [layout]
    }
    
    var layouts: [Layout]
    
    var activatedLayout: Layout?
    
    func bind<Layoutable>(_ layout: Layoutable) where Layoutable : Layout {
        layouts.append(layout)
    }
    
    func active() {
        layouts.forEach { layout in
            layout.attachSuperview()
        }
    }
    
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        for layoutable in layouts {
            if layoutable.hashable == layout.hashable {
                activatedLayout = layoutable
                layoutable.attachSuperview()
            } else {
                layoutable.detachFromSuperview()
            }
        }
    }
    
    func deactive() {
        for layout in layouts {
            layout.detachFromSuperview()
        }
    }
    
    func layoutIsActivating<Layoutable>(_ layout: Layoutable) -> Bool where Layoutable : Layout {
        activatedLayout?.hashable == layout.hashable
    }
}

final class Activation: Deactivatable {
    
    private(set) var box: ActivationBox?
    
    init() {
        box = nil
    }
    
    convenience init<Layoutable: Layout>(_ layout: Layoutable) {
        self.init(_ActivationBox(layout))
    }
    
    init<Box: ActivationBox>(_ box: Box?) {
        self.box = box
    }
    
    deinit {
        deactive()
    }
    
    public func active() {
        self.box?.active()
    }
    
    public func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        self.box?.active(layout)
    }
    
    public func deactive() {
        self.box?.deactive()
        self.box = nil
    }
    
    func isNew(_ layout: Layout) -> Bool {
        guard let layouts = self.box?.layouts else { return true }
        if layouts.count == 1 {
            return layouts[0].hashable != layout.hashable
        } else {
            return !layouts.map(\.hashable).contains(layout.hashable)
        }
    }
    
}

