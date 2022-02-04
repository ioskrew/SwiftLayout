//
//  AnyDeactivatable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

protocol _AnyDeactiveLayout {
    
    var layouts: [Layout] { get }
    
    func active()
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
    func deactive()
    func layoutIsActivating<Layoutable>(_ layout: Layoutable) -> Bool where Layoutable: Layout
    
    func bind<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
}

final class AnyDeactiveBox<Layoutable: Layout>: _AnyDeactiveLayout {
    
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
            layout.reactive()
        }
    }
    
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        for layoutable in layouts {
            if layoutable.hashable == layout.hashable {
                activatedLayout = layoutable
                layoutable.reactive()
            } else {
                layoutable.deactive()
            }
        }
    }
    
    func deactive() {
        for layout in layouts {
            layout.deactiveRoot()
        }
    }
    
    func layoutIsActivating<Layoutable>(_ layout: Layoutable) -> Bool where Layoutable : Layout {
        activatedLayout?.hashable == layout.hashable
    }
}

public final class AnyDeactivatable {
    
    let box: _AnyDeactiveLayout?
    
    init() {
        box = nil
    }
    
    convenience init<Layoutable: Layout>(_ layout: Layoutable) {
        self.init(AnyDeactiveBox(layout))
    }
    
    init<Box: _AnyDeactiveLayout>(_ box: Box?) {
        self.box = box
    }
    
    deinit {
        box?.deactive()
    }
    
    public func bind<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        if let layout = layout as? SuperSubLayoutable {
            layout.deactivatable = self
        }
        box?.bind(layout)
    }
    
    public func active() {
        self.box?.active()
    }
    
    public func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        self.box?.active(layout)
    }
    
    public func deactive() {
        self.box?.deactive()
    }
    
    public func layoutIsActivating<Layoutable>(_ layout: Layoutable) -> Bool where Layoutable: Layout {
        guard let box = box else {
            return false
        }
        return box.layoutIsActivating(layout)
    }
}

