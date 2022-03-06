//
//  LayoutBuilding+SwiftUI.swift
//  
//
//  Created by oozoofrog on 2022/02/06.
//

import Foundation
import UIKit
import SwiftUI

public protocol LayoutableViewRepresentable: UIViewRepresentable, Layoutable {}
public protocol LayoutableViewControllerRepresentable: UIViewControllerRepresentable, Layoutable {}

public extension LayoutableViewRepresentable where Self: UIView {
    func makeUIView(context: UIViewRepresentableContext<Self>) -> Self {
        self
    }
    func updateUIView(_ uiView: Self, context: UIViewRepresentableContext<Self>) {
        uiView.updateLayout()
    }
}

public extension LayoutableViewControllerRepresentable where Self: UIViewController {
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> Self {
        self
    }
    func updateUIViewController(_ uiViewController: Self, context: UIViewControllerRepresentableContext<Self>) {
        uiViewController.updateLayout()
    }
}
