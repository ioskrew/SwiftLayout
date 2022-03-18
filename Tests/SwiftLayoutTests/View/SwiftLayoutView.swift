//
//  SwiftLayoutView.swift
//  SwiftLayout-Performance-Test
//
//  Created by aiden_h on 2022/03/17.
//

import UIKit
import SwiftLayout

class SwiftLayoutView: UIView, Layoutable {
    
    let header = HeaderLayout()
    let wallet = WalletLayout()
    let servicelist0 = ServiceList0()
    let servicelist1 = ServiceList1()
    let introduction = IntroductionLayout()
    let news = NewsLayout()
    let option = OptionLayout()
    
    var layout: some Layout {
        self.config {
            $0.backgroundColor = .systemBackground
        }.sublayout {
            header(self)
            wallet(self)
            servicelist0(self)
            servicelist1(self)
            introduction(self)
            news(self)
            option(self)
        }
    }
    
    var activation: Activation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let date = Date()
        self.sl.updateLayout()
        print("SwiftLayoutView updateLayout time: \(-date.timeIntervalSinceNow)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.sl.updateLayout()
    }
}
