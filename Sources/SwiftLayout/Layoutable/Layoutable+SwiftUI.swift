//
//  Layoutable+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation

public protocol LayoutableViewRepresentable: SLViewRepresentable, Layoutable {}
public protocol LayoutableViewControllerRepresentable: SLViewControllerRepresentable, Layoutable {}

public extension LayoutableViewRepresentable where Self: SLView {
    func makeUIView(context: SLViewRepresentableContext<Self>) -> Self {
        return self
    }
    func updateUIView(_ view: Self, context: SLViewRepresentableContext<Self>) {
        view.sl.updateLayout()
    }
}

public extension LayoutableViewControllerRepresentable where Self: SLViewController {
    func makeUIViewController(context: SLViewControllerRepresentableContext<Self>) -> Self {
        return self
    }
    func updateUIViewController(_ viewController: Self, context: SLViewControllerRepresentableContext<Self>) {
        viewController.sl.updateLayout()
    }
}
