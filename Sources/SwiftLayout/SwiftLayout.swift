//
//  File.swift
//  
//
//  Created by oozoofrog on 2022/01/25.
//

import Foundation
import UIKit

public struct SwiftLayout {}

public protocol Layoutable: CustomDebugStringConvertible {
    
    var branches: [Layoutable] { get }
    
    func isEqualLayout(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ layoutable: Layoutable) -> Bool
    func isEqualView(_ view: UIView?) -> Bool
    
    var layoutIdentifier: String { get }
}

extension Layoutable {
    public var branches: [Layoutable] { [] }
}
