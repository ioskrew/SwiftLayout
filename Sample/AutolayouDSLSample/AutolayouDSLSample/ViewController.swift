//
//  ViewController.swift
//  AutolayouDSLSample
//
//  Created by oozoofrog on 2022/01/14.
//

import SwiftUI
import UIKit
import AutolayoutDSL

class ViewController: UIViewController {
    
    var flag: Bool = true
    
    init(_ flag: Bool) {
        self.flag = flag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Start")
        view.backgroundColor = .white
        view.accessibilityIdentifier = "VC.View"
        
        let yellow = UIView()
        yellow.backgroundColor = .yellow
        yellow.accessibilityIdentifier = "YELLOW"
        
        let green = UIView()
        green.backgroundColor = .green
        green.accessibilityIdentifier = "GREEN"
        
        let red = UIView()
        red.backgroundColor = .red
        red.accessibilityIdentifier = "RED"
        
        let blue = UIView()
        blue.backgroundColor = .blue
        blue.accessibilityIdentifier = "BLUE"
        
        let result = view {
            yellow {
                green
            }
            red {
                blue
            }
        }
        
        print(result.dsl.debugDescription)
    }

}
