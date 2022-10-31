//
//  ChainLayout.swift
//  
//
//  Created by oozoofrog on 2022/10/15.
//

import Foundation

public struct ChainLayout<CurrentLayout: Layout, NextLayout: Layout>: Layout {

    let currentLayout: CurrentLayout
    let nextLayout: NextLayout

    init(_ currentLayout: CurrentLayout, _ nextLayout: NextLayout) {
        self.currentLayout = currentLayout
        self.nextLayout = nextLayout
    }

    public var sublayouts: [Layout] {
        [currentLayout] + nextLayout.sublayouts
    }
}

public struct ChainCut: Layout {
    public let sublayouts: [Layout] = []

    init() {}
}

extension ChainLayout where NextLayout == ChainCut {
    init(_ currentLayout: CurrentLayout) {
        self.currentLayout = currentLayout
        self.nextLayout = ChainCut()
    }

    public var sublayouts: [Layout] { [currentLayout] }
}
