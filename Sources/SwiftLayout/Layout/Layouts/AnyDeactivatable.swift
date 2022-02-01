//
//  AnyDeactivatable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

protocol _AnyDeactiveLayout {
    func active()
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
    func deactive()
    
    func bind<Layoutable>(_ layout: Layoutable) where Layoutable: Layout
}

final class AnyDeactiveBox<Layoutable: Layout>: _AnyDeactiveLayout {
    
    internal init(_ layout: Layoutable) {
        self.layoutables = [layout]
    }
    
    var layoutables: [Layout]
    
    func bind<Layoutable>(_ layout: Layoutable) where Layoutable : Layout {
        layoutables.append(layout)
    }
    
    func active() {
        layoutables.forEach { layout in
            layout.reactive()
        }
    }
    
    func active<Layoutable>(_ layout: Layoutable) where Layoutable: Layout {
        for layoutable in layoutables {
            if layoutable.hashable == layout.hashable {
                layoutable.reactive()
            } else {
                layoutable.deactive()
            }
        }
    }
    
    func deactive() {
        layoutables.forEach { layout in
            layout.deactiveRoot()
        }
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
}

