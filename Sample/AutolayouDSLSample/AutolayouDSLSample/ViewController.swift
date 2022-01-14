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
    
    let flag: Bool
    
    init(_ flag: Bool) {
        self.flag = flag
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let yellow = UIView()
        yellow.backgroundColor = .yellow
       
        let blue = UIView()
        blue.backgroundColor = .blue
        
        view.fill {
            if flag {
                yellow
            } else {
                blue
            }
        }.active()
    }

}
