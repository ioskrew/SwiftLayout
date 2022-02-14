//
//  Optional+Layout.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

extension Optional: Layout where Wrapped: Layout {
    
    public var sublayouts: [Layout] { self?.sublayouts ?? [] }
    
    public var layoutViews: [ViewInformation] { self?.layoutViews ?? [] }
    
    public var layoutConstraints: [NSLayoutConstraint] { self?.layoutConstraints ?? [] }
    
    public func prepareSuperview(_ superview: UIView?) {
        self?.prepareSuperview(superview)
    }
    
    public func prepareConstraints(_ identifiers: ViewIdentifiers) {
        self?.prepareConstraints(identifiers)
    }
    
}
