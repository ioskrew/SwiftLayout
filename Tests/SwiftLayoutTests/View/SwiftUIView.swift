//
//  ContentView.swift
//  Sample
//
//  Created by oozoofrog on 2022/03/21.
//

import SwiftUI

@available(iOS 15.0, *)
struct SwiftUIView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Hello SwiftLayout")
                    .font(.system(size: 23))
                    .fontWeight(.semibold)
                    .padding(.leading, 16)
                Spacer()
                ForEach(["magnifyingglass", "qrcode.viewfinder", "music.note", "gearshape"], id: \.self) {
                    name in
                    Button(action: {}, label: { Image(systemName: name) })
                        .frame(width: 40, height: 40)
                }
            }
            .foregroundColor(.white)
            .frame(height: 60)
            VStack(spacing: 0) {
                HStack {
                    Text("Wallet")
                        .font(.system(size: 21))
                        .fontWeight(.medium)
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black.opacity(0.3))
                    Spacer()
                    Button(action: {}) {
                        Label("Certification", systemImage: "lock.shield")
                    }
                    seperator
                    Button(action: {}) {
                        Label("QR Check in", systemImage: "qrcode")
                    }
                }
                .foregroundColor(Color.black)
                .frame(height: 60)
                HStack {
                    Image(systemName: "qrcode")
                    Text("Notice").font(.system(size: 15))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 10)
                .frame(height: 40)
                .background(Color.white)
                .padding(.bottom, 15)
                HStack(spacing: 0) {
                    Image(systemName: "applelogo")
                        .font(.system(size: 12))
                    Text("pay").font(.system(size: 16, weight: .medium))
                        .padding(.leading, 4)
                    Spacer()
                    Text("$ 235,711.13").font(.system(size: 14))
                }
                HStack(spacing: 0) {
                    Text("transfer")
                    seperator
                    Text("payment")
                    seperator
                    Text("assets")
                    Spacer()
                    Label("Purchases", systemImage: "cart")
                }
                .frame(height: 31)
                .padding(.top, 10)
                Spacer()
            }
            .padding(.horizontal, 16)
            .frame(height: 190)
            .background(Color.brown)
            LazyVGrid(columns: Array<GridItem>.init(repeating: GridItem(), count: 4)) {
                grid(systemName: "envelope", text: "Mail")
                grid(systemName: "calendar", text: "Mail")
                grid(systemName: "folder", text: "Mail")
                grid(systemName: "puzzlepiece", text: "Mail")
                grid(systemName: "envelope", text: "Mail")
                grid(systemName: "calendar", text: "Mail")
                grid(systemName: "folder", text: "Mail")
                grid(systemName: "puzzlepiece", text: "Mail")
            }
            .padding(.top, 10)
            HStack {
                Image(systemName: "square.stack.3d.down.forward")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.red)
                    .frame(width: 60, height: 60)
                    .padding(.leading, 10)
                VStack(spacing: 5) {
                    HStack {
                        Text("Hello SwiftLayout")
                            .font(.system(size: 20, weight: .semibold))
                        Spacer()
                    }
                    Text("SwiftLayout is a DSL library that composes views and creates constraints through a more swifty syntax when using UIKit/AppKit.")
                        .lineLimit(2)
                        .font(.system(size: 12))
                        .padding(.bottom, 8)
                }.foregroundColor(.white)
            }
            .frame(height: 80)
            .background(Color.white.opacity(0.2))
            HStack {
                Text("News")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            topic(title: "Topic 1", description: "DSL features for addSubview and removeFromSuperview DSL features for NSLayoutConstraint, NSLayoutAnchor and activation", systemName: "newspaper")
            topic(title: "Topic 2", description: "using conditional and loop statements like if else, swift case, for in view hierarhcy and autolayout constraints.", systemName: "doc.text")
            option(title: "Option 1")
            option(title: "Option 2")
            Spacer()
        }
    }
    
    var seperator: some View {
        Spacer()
            .frame(width: 1, height: 15)
            .background(Color.black.opacity(0.3))
            .padding(.horizontal)
    }
    
    func grid(systemName: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .tint(.white)
                .frame(width: 40, height: 40)
            Text(text).font(.system(size: 12))
        }
        .foregroundColor(.white)
    }
    
    func topic(title: String, description: String, systemName: String) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 21, weight: .semibold))
                Text(description)
                    .lineLimit(2)
                    .font(.system(size: 10))
                    .padding(.bottom, 8)
            }.foregroundColor(.white)
            Spacer()
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundColor(Color.white)
                .frame(width: 50, height: 50)
                .padding(.leading, 10)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.2))
    }
    
    func option(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 17))
            Spacer()
            Toggle(isOn: .constant(true), label: { EmptyView() })
        }
        .frame(height: 50)
    }
}

@available(iOS 15.0, *)
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
            .previewDevice(PreviewDevice(stringLiteral: "iPhone 13 Pro Max"))
            .background(Color.black)
    }
}
