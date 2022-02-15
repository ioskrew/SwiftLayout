//
//  ComplicatedRootView.swift
//  SwiftLayoutSample
//
//  Created by oozoofrog on 2022/02/15.
//

import Foundation
import UIKit
import SwiftLayout
import SwiftUI

final class ComplicatedRootView: UIView, LayoutBuilding {
    
    lazy var view = ComplicatedView()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var deactivable: Deactivable?
    
    var layout: some Layout {
        self {
            contentView.anchors {
                Anchors.cap
            }.subviews {
                ComplicatedView().anchors {
                    Anchors.boundary
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ComplicatedRootView: LayoutViewRepresentable {}

struct ComplicatedRootView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicatedRootView()
    }
}
