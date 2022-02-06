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

public protocol LayoutViewPreview where Self: UIView, Self: UIViewRepresentable, Self: SwiftUI.PreviewProvider {
    static var layoutBuildingPreviews: Self { get }
}

extension LayoutBuilding where Self: LayoutViewPreview {
    public static var previews: Self {
        self.layoutBuildingPreviews
    }
}

public protocol LayoutViewControllerPreview where Self: UIViewController, Self: UIViewControllerRepresentable, Self: SwiftUI.PreviewProvider {
    static var layoutBuildingPreviews: Self { get }
}

extension LayoutBuilding where Self: LayoutViewControllerPreview {
    public static var previews: Self {
        self.layoutBuildingPreviews
    }
}


public class LayoutBuildingContext {
    var deactivatable: AnyDeactivatable?
}

#endif
