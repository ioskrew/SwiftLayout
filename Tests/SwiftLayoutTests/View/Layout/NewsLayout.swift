//
//  NewsLayout.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

struct NewsLayout {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().identifying("NewsView").anchors {
            Anchors(.top).equalTo("introductionView", attribute: .bottom, constant: 8.0)
            Anchors(.leading).equalTo(superview.safeAreaLayoutGuide, constant: 16.0)
            Anchors(.trailing).equalTo(superview.safeAreaLayoutGuide, constant: -16.0)
            Anchors(.height).equalTo(constant: 170.0)
        }.sublayout {
            UILabel().identifying("NewsTitle").config {
                $0.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
                $0.text = "News"
                $0.textColor = .label
            }.anchors {
                Anchors(.leading, .top)
                Anchors(.height).equalTo(constant: 24.0)
            }
            
            UIView().config {
                $0.backgroundColor = .separator
            }.identifying("NewsTopic1").anchors {
                Anchors(.top).equalTo("NewsTitle", attribute: .bottom, constant: 8.0)
                Anchors(.leading, .trailing)
                Anchors(.height).equalTo("NewsTopic2").setMultiplier(1.0)
            }.sublayout {
                UILabel().identifying("NewsTopic1Title").config {
                    $0.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
                    $0.text = "Topic 1"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.top).equalTo(constant: 8.0)
                    Anchors(.leading).equalTo(constant: 10.0)
                    Anchors(.height).equalTo(constant: 18.0)
                }
                
                UILabel().identifying("NewsTopic1Description").config {
                    $0.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
                    $0.numberOfLines = 0
                    $0.text = "DSL features for addSubview and removeFromSuperview DSL features for NSLayoutConstraint, NSLayoutAnchor and activation"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.leading).equalTo("NewsTopic1Title")
                    Anchors(.top).equalTo("NewsTopic1Title", attribute: .bottom, constant: 2.0)
                    Anchors(.bottom).equalTo(constant: -8.0)
                }
                
                UIImageView().config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "newspaper")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("NewsTopic1Description", attribute: .trailing, constant: 10.0)
                    Anchors(.height, .width).equalTo(constant: 50.0)
                    Anchors(.trailing).equalTo(constant: -10.0)
                }
            }
            
            UIView().config {
                $0.backgroundColor = .separator
            }.identifying("NewsTopic2").anchors {
                Anchors(.top).equalTo("NewsTopic1", attribute: .bottom, constant: 8.0)
                Anchors(.leading, .trailing, .bottom)
            }.sublayout {
                UILabel().identifying("NewsTopic2Title").config {
                    $0.font = UIFont.systemFont(ofSize: 21.0, weight: .semibold)
                    $0.text = "Topic 2"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.top).equalTo(constant: 8.0)
                    Anchors(.leading).equalTo(constant: 10.0)
                    Anchors(.height).equalTo(constant: 18.0)
                }
                
                UILabel().identifying("NewsTopic2Description").config {
                    $0.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
                    $0.numberOfLines = 0
                    $0.text = "using conditional and loop statements like if else, swift case, for in view hierarhcy and autolayout constraints."
                    $0.textColor = .label
                }.anchors {
                    Anchors(.leading).equalTo("NewsTopic2Title")
                    Anchors(.top).equalTo("NewsTopic2Title", attribute: .bottom, constant: 2.0)
                    Anchors(.bottom).equalTo(constant: -8.0)
                }
                
                UIImageView().config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "doc.text")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.centerY)
                    Anchors(.leading).equalTo("NewsTopic2Description", attribute: .trailing, constant: 10.0)
                    Anchors(.height, .width).equalTo(constant: 50.0)
                    Anchors(.trailing).equalTo(constant: -10.0)
                }
            }
        }
    }
}
