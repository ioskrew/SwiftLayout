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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let yellow = UIView()
        yellow.backgroundColor = .yellow
        
        view.fill {
            yellow
        }.active()
    }

}
