//
//  Set+Activation.swift
//
//
//  Created by oozoofrog on 2022/02/23.
//

import SwiftLayoutPlatform

public extension Collection where Element: Activation {
    /// Finds a view by its accessibility identifier across multiple activations.
    ///
    /// Use this method to locate views when you have multiple active layouts:
    ///
    /// ```swift
    /// var activations: [Activation] = []
    ///
    /// layout1.active().store(&activations)
    /// layout2.active().store(&activations)
    ///
    /// if let headerView = activations.viewForIdentifier("header") {
    ///     // Found the view
    /// }
    /// ```
    ///
    /// - Parameter identifier: The accessibility identifier to search for.
    /// - Returns: The first view matching the identifier, or `nil` if not found.
    @MainActor
    func viewForIdentifier(_ identifier: String) -> SLView? {
        for activation in self {
            guard let view = activation.viewForIdentifier(identifier) else { continue }
            return view
        }
        return nil
    }
}
