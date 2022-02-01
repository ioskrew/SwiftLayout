//
//  AnyDeactivatable.swift
//  
//
//  Created by oozoofrog on 2022/02/01.
//

import Foundation

protocol _AnyDeactiveLayout {
    func deactive()
}

struct AnyDeactiveBox<Layoutable: Layout>: _AnyDeactiveLayout {
    let layoutable: Layoutable
    
    func deactive() {
        layoutable.deactive()
    }
}

public final class AnyDeactivatable {
    
    let box: _AnyDeactiveLayout?
    
    init() {
        box = nil
    }
    
    convenience init<Layoutable: Layout>(_ layout: Layoutable) {
        self.init(AnyDeactiveBox(layoutable: layout))
    }
    
    init<Box: _AnyDeactiveLayout>(_ box: Box?) {
        self.box = box
    }
    
    deinit {
        box?.deactive()
    }
    
    public func deactive() {
        self.box?.deactive()
    }
}

