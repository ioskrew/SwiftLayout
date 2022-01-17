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
        
        let yellow = UIView()
        yellow.backgroundColor = .yellow
        
        let green = UIView()
        green.backgroundColor = .green
        
        let red = UIView()
        red.backgroundColor = .red
        
        let blue = UIView()
        blue.backgroundColor = .blue
        
        let result = view.dsl.tag("VC.View") {
            yellow {
                green.dsl.tag("GREEN")
            }.tag("YELLOW")
            red {
                blue.dsl.tag("BLUE")
            }.tag("RED")
        }
        
        print(result.debugDescription)
    }

}
