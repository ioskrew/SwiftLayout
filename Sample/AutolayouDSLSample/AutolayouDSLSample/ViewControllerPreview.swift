//
//  ViewControllerPreview.swift
//  AutolayouDSLSample
//
//  Created by oozoofrog on 2022/01/14.
//

import SwiftUI


struct ViewController_Preview: PreviewProvider {
    
    struct ViewControllerView: UIViewControllerRepresentable {
        
        let flag: Bool
        
        func makeUIViewController(context: Context) -> some UIViewController {
            ViewController(flag)
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
    }
    
    static var previews: some View {
        ViewControllerView(flag: true).previewDevice(.init(rawValue: "iPhone 13 Pro Max"))
        ViewControllerView(flag: false).previewDevice(.init(rawValue: "iPhone 13 Pro Max"))
    }
    
}
