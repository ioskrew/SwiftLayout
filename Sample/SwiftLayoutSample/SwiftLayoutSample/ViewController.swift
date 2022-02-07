//
//  ViewController.swift
//  SwiftLayoutSample
//
//  Created by oozoofrog on 2022/02/07.
//

import UIKit
import SwiftLayout
import SwiftUI

final class ViewController: UIViewController, LayoutBuilding {

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
    
    var redUp = true {
        didSet { updateLayout() }
    }
    var layout: some Layout {
        view {
            if redUp {
                // TODO: should be more simple
                red.constraint(.top, .leading, .trailing)
                    .constraint(.bottom, to: (blue, .top))
                blue.constraint(.leading, .trailing, .bottom)
                    .constraint(.height, toItem: red).layout {
                        UIButton(primaryAction: UIAction(title: "blue up", handler: { [weak self] _ in
                            self?.redUp = false
                        })).constraint(.centerY, .centerX)
                    }
            } else {
                blue.constraint(.top, .leading, .trailing)
                    .constraint(.bottom, to: (red, .top))
                red.constraint(.leading, .trailing, .bottom)
                    .constraint(.height, toItem: blue).layout {
                        UIButton(primaryAction: UIAction(title: "red up", handler: { [weak self] _ in
                            self?.redUp = true
                        })).constraint(.centerY, .centerX)
                    }
            }
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

extension ViewController: LayoutViewControllerRepresentable {}

struct ViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        ViewController(nibName: nil, bundle: nil)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
    
}
