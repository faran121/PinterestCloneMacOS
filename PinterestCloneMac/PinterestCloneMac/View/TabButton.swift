//
//  TabButton.swift
//  PinterestCloneMac
//
//  Created by Maliks on 30/03/2024.
//

import SwiftUI

struct TabButton: View {
    
    var image: String
    var title: String
    var animation: Namespace.ID
    
    @Binding var selected: String
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                selected = title
            }
        }) {
            HStack {
                Image(systemName: image)
                    .font(.title2)
                    .foregroundStyle(selected == title ? Color.black : black)
                    .frame(width: 25)
                
                Text(title)
                    .fontWeight(selected == title ? .semibold : .none)
                    .foregroundStyle(selected == title ? Color.black : black)
                    .animation(.none)
                
                Spacer()
                
                ZStack {
                    Capsule()
                        .fill(Color.clear)
                        .frame(width: 3, height: 25)
                    
                    if selected == title {
                        Capsule()
                            .fill(Color.black)
                            .frame(width: 3, height: 25)
                            .matchedGeometryEffect(id: "Tab", in: self.animation)
                    }
                }
            }
            .padding(.leading)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

var black = Color.black.opacity(0.5)
