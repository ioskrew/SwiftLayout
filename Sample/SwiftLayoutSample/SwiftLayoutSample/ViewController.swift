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
    
    var deactivable: Deactivable?
    
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
        didSet { updateLayout(animated: true) }
    }
    
    var button: UIButton {
        let button = UIButton(primaryAction: .init(title: redUp ? "down" : "up", handler: { [weak self] _ in
            self?.redUp.toggle()
        }))
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    var nextButton: UIButton {
        let button = UIButton(primaryAction: UIAction(title: "NEXT", handler: { [weak self] _ in
            guard let self = self else { return }
            let label = UILabel()
            label.text = "HELLO"
            self.navigationController?.pushViewController(LayoutHostingViewController({ view in
                view {
                    label.anchors {
                        Anchors.center
                    }
                }
            }), animated: true)
        }))
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
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
                    Anchors.horizontal
                    Anchors(.bottom).equalTo(view.safeAreaLayoutGuide, attribute: .bottom)
                } else {
                    Anchors.cap
                }
                Anchors.center.equalTo("next")
            }.subviews {
                nextButton.identifying("next").animationDisable()
            }
        }
    }
    
    static var layoutBuildingPreviews: ViewController {
        ViewController(nibName: nil, bundle: nil)
    }
    
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
