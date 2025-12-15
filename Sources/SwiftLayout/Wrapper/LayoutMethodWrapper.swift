//
//  LayoutMethodWrapper.swift
//
//
//  Created by oozoofrog on 2022/03/13.
//

import SwiftLayoutPlatform

/// A wrapper type that provides SwiftLayout extensions for SLView and SLLayoutGuide.
///
/// Access through the `.sl` property on compatible types:
/// ```swift
/// view.sl.anchors { ... }
/// view.sl.sublayout { ... }
/// layoutGuide.sl.anchors { ... }
/// ```
///
/// - Note: Public API is defined in `LayoutMethodWrapper+UIView.swift` and `LayoutMethodWrapper+UILayoutGuide.swift`.
@MainActor
public struct LayoutMethodWrapper<Base: LayoutMethodAccessible> {
    let base: Base
}
