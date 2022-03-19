//
//  Layoutable+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import SwiftUI

public protocol LayoutableViewRepresentable: UIViewRepresentable, Layoutable {}
public protocol LayoutableViewControllerRepresentable: UIViewControllerRepresentable, Layoutable {}

public extension LayoutableViewRepresentable where Self: UIView {
    func makeUIView(context: UIViewRepresentableContext<Self>) -> Self {
        return self
    }
    func updateUIView(_ view: Self, context: UIViewRepresentableContext<Self>) {
        view.sl.updateLayout()
    }
}

public extension LayoutableViewControllerRepresentable where Self: UIViewController {
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> Self {
        return self
    }
    func updateUIViewController(_ viewController: Self, context: UIViewControllerRepresentableContext<Self>) {
        viewController.sl.updateLayout()
    }
}
