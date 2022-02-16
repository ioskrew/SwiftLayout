//
//  LayoutHostingViewController.swift
//  
//
//  Created by oozoofrog on 2022/02/11.
//

import Foundation
import UIKit
import SwiftLayout

class LayoutHostingViewController: UIViewController, LayoutBuilding {
    
    var deactivable: Deactivable?
    
    var content: (UIView) -> Layout
    
    var layout: Layout {
        content(self.view)
    }
    
    init(_ content: @escaping (UIView) -> Layout) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
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
