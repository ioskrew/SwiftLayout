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
        self.deactivatable = self.active()
        return self
    }
    
    public func updateUIView(_ uiView: Self, context: Context) {
        uiView.updateLayout()
    }
    
}

public protocol LayoutBuildingPreviewProviding where Self: UIView, Self: UIViewRepresentable, Self: SwiftUI.PreviewProvider {
    static var layoutBuildingPreviews: Self { get }
}

extension LayoutBuilding where Self: LayoutBuildingPreviewProviding {
    public static var previews: Self {
        self.layoutBuildingPreviews
    }
}

public class LayoutBuildingContext {
    var deactivatable: AnyDeactivatable?
}

#endif
