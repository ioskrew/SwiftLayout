//
//  Layoutable+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/04/01.
//

import SwiftUI
import UIKit

public extension LayoutMethodWrapper where Base: Layoutable&UIView {
    var swiftUI: SLViewRepresentable<Base> {
        return SLViewRepresentable(base)
    }
}

public extension LayoutMethodWrapper where Base: Layoutable&UIViewController {
    var swiftUI: SLViewControllerRepresentable<Base> {
        return SLViewControllerRepresentable(base)
    }
}

public struct SLViewRepresentable<L: Layoutable&UIView>: UIViewRepresentable {

    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> L {
        return layoutable
    }
    public func updateUIView(_ uiView: L, context: UIViewRepresentableContext<Self>) {
        layoutable.sl.updateLayout()
    }
}

public struct SLViewControllerRepresentable<L: Layoutable&UIViewController>: UIViewControllerRepresentable {

    let layoutable: L

    init(_ layoutable: L) {
        self.layoutable = layoutable
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> L {
        return layoutable
    }
    public func updateUIViewController(_ uiViewController: L, context: UIViewControllerRepresentableContext<Self>) {
        uiViewController.sl.updateLayout()
    }
}
