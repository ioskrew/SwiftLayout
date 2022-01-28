//
//  AnchorBox.swift
//  
//
//  Created by oozoofrog on 2022/01/29.
//

import Foundation
import UIKit

protocol AnchorBox {
    ///
    /// 다른 AnchorBox 구현체의 값을 사용하여 NSLayoutConstraint를 반환한다
    ///
    /// - Parameter anchor: AnchorBox 구현체
    /// - Returns: NSLayoutConstraint?을 반환. anchor의 AnchorType이 서로 다를 경우 nil을 반환한다.
    func constraint(equalTo anchor: AnchorBox) -> NSLayoutConstraint?
}

struct LayoutAnchorBox<AnchorType>: AnchorBox where AnchorType: AnyObject {
    
    internal init(_ layoutAnchor: NSLayoutAnchor<AnchorType>) {
        self.layoutAnchor = layoutAnchor
    }
    
    let layoutAnchor: NSLayoutAnchor<AnchorType>
    
    func constraint(equalTo anchor: AnchorBox) -> NSLayoutConstraint? {
        guard let anchor = anchor as? Self else { return nil }
        return self.layoutAnchor.constraint(equalTo: anchor.layoutAnchor)
    }
    
}
