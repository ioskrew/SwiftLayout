//
//  Set+Activation.swift
//  
//
//  Created by oozoofrog on 2022/02/23.
//

import SwiftLayoutPlatform

public extension Collection where Element: Activation {
    @MainActor
    func viewForIdentifier(_ identifier: String) -> SLView? {
        for activation in self {
            guard let view = activation.viewForIdentifier(identifier) else { continue }
            return view
        }
        return nil
    }
}
