//
//  Layoutable+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/04/01.
//

import UIKit
import SwiftUI

public extension LayoutableMethodWrapper where L: Layoutable&UIView {
    var swiftUI: SwiftLayoutSwiftUIRepresentable<L>? {
        guard let layoutable = self.layoutable else { return nil }
        return SwiftLayoutSwiftUIRepresentable(layoutable: layoutable)
    }
}

public extension LayoutableMethodWrapper where L: Layoutable&UIViewController {
    var swiftUI: SwiftLayoutSwiftUIRepresentable<L>? {
        guard let layoutable = self.layoutable else { return nil }
        return SwiftLayoutSwiftUIRepresentable(layoutable: layoutable)
    }
}

public struct SwiftLayoutSwiftUIRepresentable<L: Layoutable>: SwiftUI.View {
    public typealias Body = Never
    
    public var body: Never {
        fatalError()
    }
    
    let layoutable: L
}

extension SwiftLayoutSwiftUIRepresentable: UIViewRepresentable where L: Layoutable&UIView {
    public func makeUIView(context: UIViewRepresentableContext<Self>) -> L {
        layoutable
    }
    public func updateUIView(_ uiView: L, context: UIViewRepresentableContext<Self>) {
        layoutable.sl.updateLayout()
    }
}

extension SwiftLayoutSwiftUIRepresentable: UIViewControllerRepresentable where L: Layoutable&UIViewController {
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> L {
        layoutable
    }
    public func updateUIViewController(_ uiViewController: L, context: UIViewControllerRepresentableContext<Self>) {
        layoutable.sl.updateLayout()
    }
}
