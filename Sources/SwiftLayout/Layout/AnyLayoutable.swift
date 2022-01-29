//
//  AnyLayoutable.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation

private protocol AnyLayoutableBox: Layoutable {
    
}

struct LayoutableBox<L: Layoutable>: AnyLayoutableBox {
 
    let layoutable: L
    
    func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        self.layoutable.moveToSuperlayoutable(layoutable)
    }
    
}

public struct AnyLayoutable: Layoutable {
    
    private let box: AnyLayoutableBox
    
    init<L: Layoutable>(_ box: LayoutableBox<L>) {
        self.box = box
    }
    
    public func moveToSuperlayoutable(_ layoutable: Layoutable) -> Layoutable {
        self.box.moveToSuperlayoutable(layoutable)
    }
}
