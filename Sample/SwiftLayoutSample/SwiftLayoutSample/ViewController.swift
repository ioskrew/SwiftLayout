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
    
    lazy var button: UIButton = {
        let button = UIButton(primaryAction: .init(title: "RED!!!!", handler: { [weak self] _ in
            self?.redUp.toggle()
        }))
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 90)
        return button
    }()
    
    var layout: some Layout {
        view {
            red.anchors {
                if redUp {
                    Anchors.cap
                    Anchors(.bottom).equalTo(blue, attribute: .top)
                } else {
                    Anchors.shoe
                    Anchors(.top).equalTo(blue, attribute: .bottom)
                }
                Anchors(.height).equalTo(blue, attribute: .height)
            }.subviews {
                button.anchors {
                    Anchors.center
                }
            }
            blue.anchors {
                if redUp {
                    Anchors.shoe
                } else {
                    Anchors.cap
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

extension Anchors {
    static var cap: Anchors { .init(.top, .leading, .trailing) }
    static var shoe: Anchors { .init(.bottom, .leading, .trailing) }
    static var center: Anchors { .init(.centerX, .centerY) }
}

extension ViewController: LayoutViewControllerRepresentable {}

struct ViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        ViewController(nibName: nil, bundle: nil)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
    
}
