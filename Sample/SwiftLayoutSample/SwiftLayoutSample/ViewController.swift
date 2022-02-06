//
//  ViewController.swift
//  SwiftLayoutSample
//
//  Created by maylee on 2022/02/07.
//

import UIKit
import SwiftLayout
import SwiftUI

final class ViewController: UIViewController, LayoutBuilding, LayoutViewControllerPreview, UIViewControllerRepresentable, PreviewProvider {

    let red: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.accessibilityIdentifier = "red"
        return view
    }()
    
    let blue: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.accessibilityIdentifier = "blue"
        return view
    }()
    
    var layout: some Layout {
        view {
            red.constraint(.top, .leading, .trailing, .bottom)
        }
    }
    
    static var layoutBuildingPreviews: ViewController {
        ViewController(nibName: nil, bundle: nil)
    }
    
    var deactivatable: AnyDeactivatable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.accessibilityIdentifier = "viewController"
        updateLayout()
    }


}
