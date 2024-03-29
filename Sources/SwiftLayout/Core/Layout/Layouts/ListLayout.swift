//
//  ListLayout.swift
//

import Foundation

public struct ListLayout<CurrentLayout: Layout, NextLayout: Layout>: Layout {

    let currentLayout: CurrentLayout
    let nextLayout: NextLayout

    init(_ currentLayout: CurrentLayout, _ nextLayout: NextLayout) {
        self.currentLayout = currentLayout
        self.nextLayout = nextLayout
    }

    public var sublayouts: [any Layout] {
        [currentLayout] + nextLayout.sublayouts
    }
}

public struct ListEndLayout: Layout {
    public let sublayouts: [any Layout] = []

    init() {}
}

extension ListLayout where NextLayout == ListEndLayout {
    init(_ currentLayout: CurrentLayout) {
        self.currentLayout = currentLayout
        self.nextLayout = ListEndLayout()
    }
}
