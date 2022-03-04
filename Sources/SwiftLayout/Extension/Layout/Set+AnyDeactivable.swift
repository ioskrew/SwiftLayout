//
//  Set+AnyDeactivable.swift
//  
//
//  Created by oozoofrog on 2022/02/23.
//

import Foundation
import UIKit

public extension Collection where Element: Deactivable {
    func viewForIdentifier(_ identifier: String) -> UIView? {
        for deactivable in self {
            guard let view = deactivable.viewForIdentifier(identifier) else { continue }
            return view
        }
        return nil
    }
}
