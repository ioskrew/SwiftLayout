//
//  LayoutMethodWrapper.swift
//
//
//  Created by oozoofrog on 2022/03/13.
//

import UIKit

/// A wrapper type that provides SwiftLayout extensions for UIView and UILayoutGuide.
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
