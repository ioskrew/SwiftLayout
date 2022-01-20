//
//  ViewController.swift
//  AutolayouDSLSample
//
//  Created by oozoofrog on 2022/01/14.
//

import SwiftUI
import UIKit
import SwiftLayout

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
        view.backgroundColor = .lightGray
        
        let yellow = UIView()
        yellow.backgroundColor = .yellow
        
        let green = UIView()
        green.backgroundColor = .green
        
        let red = UIView()
        red.backgroundColor = .red
        
        let blue = UIView()
        blue.backgroundColor = .blue
        
        let result = view {
            yellow {
                green
            }
            red {
                blue
            }
        }.layout {
            if flag {
                yellow.dsl.top.to(view)
                yellow.dsl.bottom.to(view)
                yellow.dsl.leading.to(view)
                yellow.dsl.trailing.to(view)
            } else {
                red.dsl.top.bottom.leading.trailing.to(view)
            }
        }
        
        print(result.debugDescription)
        
    }

}
