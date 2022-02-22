//
//  LayoutBuilding+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit

#if canImport(SwiftUI)
import SwiftUI

public struct LayoutViewRepresentable<V>: UIViewRepresentable where V: UIView & LayoutBuilding {
    private let view: V
    public init(_ view: V) {
        self.view = view
    }
    
    public func makeUIView(context: Context) -> V {
        return view
    }
    
    public func updateUIView(_ uiView: V, context: Context) {
        uiView.updateLayout()
    }
}


public struct LayoutViewControllerRepresentable<VC>: UIViewControllerRepresentable where VC: UIViewController & LayoutBuilding {
    private let viewController: VC
    public init(_ viewController: VC) {
        self.viewController = viewController
    }

    public func makeUIViewController(context: Context) -> VC {
        return viewController
    }

    public func updateUIViewController(_ uiViewController: VC, context: Context) {
        uiViewController.updateLayout()
    }
}

#endif
