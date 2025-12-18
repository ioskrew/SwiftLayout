//
//  ActivateMode.swift
//
//
//  Created by aiden_h on 2025/12/17.
//

/// Specifies how activation should apply layout.
public enum ActivateMode {
    /// Updates view hierarchy and constraints without forcing layout pass.
    case normal

    /// Updates view hierarchy and constraints, then forces layout pass
    /// by calling `setNeedsLayout()` and `layoutIfNeeded()`.
    case forced
}
