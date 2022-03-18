//
//  XibView.swift
//  SwiftLayout-Performance-Test
//
//  Created by aiden_h on 2022/03/17.
//

import UIKit

class XibView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let date = Date()
        self.loadXib()
        print("XibView loadXib time: \(-date.timeIntervalSinceNow)")
    }
    
    private func loadXib() {
        let identifier = String(describing: type(of: self))
        let nibs = Bundle.main.loadNibNamed(identifier, owner: self, options: nil)
        
        guard let customView = nibs?.first as? UIView else { return }
        customView.frame = self.bounds
        self.addSubview(customView)
    }
}
