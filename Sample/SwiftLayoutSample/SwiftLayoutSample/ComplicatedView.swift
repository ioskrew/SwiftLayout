//
//  ComplicatedView.swift
//  SwiftLayoutSample
//
//  Created by oozoofrog on 2022/02/15.
//

import UIKit
import SwiftLayout
import SwiftUI

final class ComplicatedView: UIView, LayoutBuilding {

    var deactivable: Deactivable?
    
    lazy var linkContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    func label(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        return label
    }
    
    var layout: some Layout {
        self {
            linkContainerView.anchors {
                Anchors.boundary
            }
            label("menu section").identifying("menu").anchors {
                Anchors.cap
            }
            label("contents section").identifying("contents").anchors {
                Anchors(.top).equalTo("menu", attribute: .bottom)
                Anchors.horizontal
            }
            label("description stack").identifying("description").anchors {
                Anchors(.top).equalTo("contents", attribute: .bottom)
                Anchors.shoe
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

extension ComplicatedView: LayoutViewRepresentable {}

struct ComplicatedView_Previews: PreviewProvider {
    static var previews: some View {
        ComplicatedView()
    }
}
