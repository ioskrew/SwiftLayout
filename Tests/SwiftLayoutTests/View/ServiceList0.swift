//
//  ServiceList0.swift
//  
//
//  Created by oozoofrog on 2022/03/18.
//

import Foundation
import UIKit
import SwiftLayout

struct ServiceList0 {
    func callAsFunction(_ superview: UIView) -> some Layout {
        UIView().identifying("serviceList0View").anchors {
            Anchors(.leading, .trailing).equalTo(superview.safeAreaLayoutGuide)
            Anchors(.top).equalTo("walletView", attribute: .bottom, constant: 15.0)
            Anchors(.height).equalTo(constant: 75.0)
        }.sublayout {
            UIView().identifying("serviceItem0").anchors {
                Anchors(.top, .leading, .bottom)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem0Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "envelope")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Mail"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem0Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem0Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem1").anchors {
                Anchors(.leading).equalTo("serviceItem0", attribute: .trailing)
                Anchors(.top, .bottom)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem1Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "calendar")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Calendar"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem1Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem1Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem2").anchors {
                Anchors(.top, .bottom)
                Anchors(.leading).equalTo("serviceItem1", attribute: .trailing)
                Anchors(.width).setMultiplier(0.25)
            }.sublayout {
                UIImageView().identifying("serviceItem2Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "folder")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Folder"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem2Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem2Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
            
            UIView().identifying("serviceItem3").anchors {
                Anchors(.top, .bottom, .trailing)
                Anchors(.leading).equalTo("serviceItem2", attribute: .trailing)
            }.sublayout {
                UIImageView().identifying("serviceItem3Image").config {
                    $0.tintColor = .label
                    $0.image = UIImage(systemName: "puzzlepiece")
                    $0.contentMode = .scaleAspectFit
                }.anchors {
                    Anchors(.top).equalTo(constant: 10.0)
                    Anchors(.centerX)
                    Anchors(.height, .width).equalTo(constant: 40.0)
                }
                
                UILabel().config {
                    $0.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
                    $0.text = "Puzzle"
                    $0.textColor = .label
                }.anchors {
                    Anchors(.centerX)
                    Anchors(.top).equalTo("serviceItem3Image", attribute: .bottom, constant: 4.0)
                }
                
                UIView().config {
                    $0.backgroundColor = .systemRed
                }.anchors {
                    Anchors(.trailing, .top).equalTo("serviceItem3Image")
                    Anchors(.width, .height).equalTo(constant: 4.0)
                }
            }
        }
    }
}
