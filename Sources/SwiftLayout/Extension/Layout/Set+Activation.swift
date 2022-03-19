//
//  Set+Activation.swift
//  
//
//  Created by oozoofrog on 2022/02/23.
//

import UIKit

public extension Collection where Element: Activation {
    func viewForIdentifier(_ identifier: String) -> UIView? {
        for activation in self {
            guard let view = activation.viewForIdentifier(identifier) else { continue }
            return view
        }
        return nil
    }
}
