//
//  LayoutBuilding+SwiftUI.swift
//  
//
//  Created by maylee on 2022/02/06.
//

import Foundation
import UIKit

#if canImport(SwiftUI)
import SwiftUI

extension SwiftUI.UIViewRepresentable where Self: UIView, Self: LayoutBuilding {
    
    public func makeUIView(context: Context) -> Self {
        return self
    }
    
    public func updateUIView(_ uiView: Self, context: Context) {
        uiView.updateLayout()
    }
    
}

extension SwiftUI.UIViewControllerRepresentable where Self: UIViewController, Self: LayoutBuilding {
    
    public func makeUIViewController(context: Context) -> Self {
        return self
    }
    
    public func updateUIViewController(_ uiViewController: Self, context: Context) {
        uiViewController.updateLayout()
    }
    
}

public protocol LayoutViewRepresentable: SwiftUI.UIViewRepresentable where Self: UIView, Self: LayoutBuilding {
    static var layoutBuildingPreviews: Self { get }
}

extension LayoutViewRepresentable {
    public static var layoutBuildingPreviews: Self {
        Self.init(frame: .zero)
    }
}

public protocol LayoutViewControllerRepresentable: SwiftUI.UIViewControllerRepresentable where Self: UIViewController, Self: LayoutBuilding {
    static var layoutBuildingPreviews: Self { get }
}

extension LayoutViewControllerRepresentable {
    public static var layoutBuildingPreviews: Self {
        Self.init(nibName: nil, bundle: nil)
    }
}

#endif
