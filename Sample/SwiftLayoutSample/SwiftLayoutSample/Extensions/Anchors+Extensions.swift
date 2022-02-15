//
//  Anchors+Extensions.swift
//  SwiftLayoutSample
//
//  Created by oozoofrog on 2022/02/15.
//

import Foundation
import SwiftLayout

extension Anchors {
    static var boundary: Anchors {
        .init(.top, .leading, .trailing, .bottom)
    }
    static var cap: Anchors { .init(.top, .leading, .trailing) }
    static var shoe: Anchors { .init(.bottom, .leading, .trailing) }
    static var horizontal: Anchors { .init(.leading, .trailing) }
    static var center: Anchors { .init(.centerX, .centerY) }
}
