//
//  LayoutHostingViewController.swift
//  
//
//  Created by oozoofrog on 2022/02/11.
//

import Foundation
import UIKit
import SwiftLayout

class LayoutHostingViewController<Content>: UIViewController, LayoutBuilding where Content: Layout {
    
    var content: ((UIView) -> Content)?
    
    var layout: some Layout {
        content?(self.view)
    }
    
    init(_ content: @escaping (UIView) -> Content) {
        super.init(nibName: nil, bundle: nil)
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateLayout()
    }
}
