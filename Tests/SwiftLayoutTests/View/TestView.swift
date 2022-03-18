//
//  TestView.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//
#if canImport(UIKit)
import UIKit
import SwiftLayout

class TestView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var descriptionContainer: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
}

class TestView2: UIView, Layoutable {

    var titleLabel = UILabel()
    var doneButton = UIButton()
    var switchLabel = UILabel()
    var switchControl = UISwitch()
    var descriptionContainer = UIView()
    var descriptionLabel = UILabel()
    
    var activation: Activation?
    
    var layout: some Layout {
        self {
            titleLabel.anchors {
                Anchors(.centerX).equalTo(self.safeAreaLayoutGuide)
                Anchors(.top).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
            }
            doneButton.anchors {
                Anchors(.firstBaseline).equalTo(titleLabel)
            }
            switchControl.anchors {
                Anchors(.centerY).equalTo(switchLabel)
            }
            switchLabel.anchors {
                Anchors(.top).equalTo(titleLabel, attribute: .bottom, constant: 61.0)
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 20.0)
            }
            descriptionContainer.anchors {
                Anchors(.leading).equalTo(self.safeAreaLayoutGuide, constant: 16.0)
                Anchors(.top).equalTo(switchLabel, attribute: .bottom, constant: 16.0)
            }.sublayout {
                descriptionLabel.anchors {
                    Anchors(.centerX, .centerY).equalTo(descriptionContainer.safeAreaLayoutGuide)
                    Anchors(.width, .height).equalTo(constant: -32.0)
                }
            }
        }
    }
    
}

#endif
