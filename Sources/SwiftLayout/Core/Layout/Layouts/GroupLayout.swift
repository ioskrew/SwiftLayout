//
//  GroupLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/01.
//

public struct GroupLayout<L: Layout>: Layout {
    
    let layout: L
    
    public init(@LayoutBuilder _ handler: () -> L) {
        self.layout = handler()
    }
    
    public var sublayouts: [Layout] {
        [layout]
    }
}
