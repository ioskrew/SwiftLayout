//
//  ChainLayout.swift
//  
//
//  Created by oozoofrog on 2022/10/15.
//

import Foundation

public protocol ChainLayoutImplement {}

public struct ChainLayout<CurrentLayout: Layout, NextLayout: Layout>: Layout, ChainLayoutImplement {

    public let currentLayout: CurrentLayout
    public let nextLayout: NextLayout

    init(_ currentLayout: CurrentLayout, _ nextLayout: NextLayout) {
        self.currentLayout = currentLayout
        self.nextLayout = nextLayout
    }
}

extension ChainLayout {

    public var sublayouts: [Layout] {
        [currentLayout] + nextLayout.sublayouts
    }

}

public struct ChainCut: Layout {
    public let sublayouts: [Layout] = []
}

extension ChainLayout where NextLayout == ChainCut {
    public var sublayouts: [Layout] { [currentLayout] }
}
